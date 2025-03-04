shader_type canvas_item;

uniform vec2 blur_amount = vec2(0.01, 0.01);
uniform vec2 focus_size = vec2(0.3, 0.2); // Define o tamanho do foco retangular
uniform float border_radius = 0.05; // Define o raio de arredondamento das quinas
uniform float opacity : hint_range(0.0, 1.0) = 1.0;

uniform float focus_x : hint_range(0.0, 1.0) = 0.5; // Posição X do foco
uniform float focus_y : hint_range(0.0, 1.0) = 0.5; // Posição Y do foco

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 focus_center = vec2(focus_x, focus_y);
    vec2 half_size = focus_size * 0.5;
    vec2 delta = abs(uv - focus_center) - half_size;

    float corner_distance = length(max(delta, vec2(0.0))) - border_radius;
    float smooth_factor = smoothstep(-0.05, 0.05, corner_distance);

    vec4 color = texture(screen_texture, uv);
    vec4 color_up = texture(screen_texture, uv + vec2(0.0, blur_amount.y));
    vec4 color_down = texture(screen_texture, uv + vec2(0.0, -blur_amount.y));
    vec4 color_left = texture(screen_texture, uv + vec2(-blur_amount.x, 0.0));
    vec4 color_right = texture(screen_texture, uv + vec2(blur_amount.x, 0.0));

    vec4 blurred_color = (color_up + color_down + color_left + color_right) / 4.0;

    COLOR = mix(color, blurred_color, smooth_factor * opacity);
}
