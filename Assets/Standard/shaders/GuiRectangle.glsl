#type vertex
#version 400 core

//VAO data
layout (location = 0) in vec2  attrib_Position;
layout (location = 1) in vec2  attrib_TextureCoord;
layout (location = 2) in float attrib_TextureIndex;

//Output VAO data to Fragment Shader.
out vec2  position;
out vec2  textureCoord;
out float textureIndex;

uniform mat4 u_ProjectionMatrix;
uniform mat4 u_ModelMatrix;

void main(void)
{
	position            = attrib_Position;
	textureCoord        = attrib_TextureCoord;
	textureIndex        = attrib_TextureIndex;

	//Position already transform by transformation on Cpu in C++ code.
	gl_Position = u_ProjectionMatrix * u_ModelMatrix * vec4(position, 0.0f, 1.0f);
}

#type fragment
#version 400 core

layout (location = 0) out vec4 out_Colour;

//Input VAO data from Vertex Shader.
in vec2  position;
in vec2  textureCoord;
in float textureIndex;

uniform sampler2D u_Texture;

uniform vec4 u_Colour;
uniform vec4 u_TintColour;
uniform float u_TextureTilingFactor;
uniform float u_DivideTileX;
uniform float u_DivideTileY;

//Discards unnecessary alpha channels from the texture 
//color.
void discardTextureColourAlpha(vec4 texOutColour, float discardValue)
{
	if(texOutColour.a < discardValue)
    	discard;
}

//Retrun tiled texture coord, apply all changes from C++ code.
vec2 tiledTextureCoord()
{
	if     (u_DivideTileX == 1) return vec2(textureCoord.x * u_TextureTilingFactor, textureCoord.y); 
	else if(u_DivideTileY == 1) return vec2(textureCoord.x, textureCoord.y * u_TextureTilingFactor);
	else if(u_DivideTileX == 1 && u_DivideTileY == 1) return textureCoord * u_TextureTilingFactor; 
}

void main(void)
{
	out_Colour = texture(u_Texture, tiledTextureCoord()) * u_Colour * u_TintColour;

	//out_Colour = colour;
}