shader_type canvas_item;

// Parâmetro para controlar o tempo shader
uniform float progress : hint_range(0, 1);

// Tamanho de cada Diamante em Pixel
uniform float diamondPixelSize = 10.0;

//Função que faz a animação do shader
void fragment() {
    float xFraction = fract(FRAGCOORD.x / diamondPixelSize);
    float yFraction = fract(FRAGCOORD.y / diamondPixelSize);
    
    float xDistance = abs(xFraction - 0.5);
    float yDistance = abs(yFraction - 0.5);
    
    if (xDistance + yDistance + UV.x + UV.y > progress * 4.0) {
        discard;
    }
}