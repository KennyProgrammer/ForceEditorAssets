#type vertex
#version 330 core

//VAO data
layout (location = 0) in vec3  attrib_Position;
layout (location = 1) in vec4  attrib_Colour;
layout (location = 2) in vec2  attrib_TextureCoord;
layout (location = 3) in float attrib_TextureIndex;
layout (location = 4) in float attrib_TextureTilingFactor;
layout (location = 5) in vec4  attrib_TintColour;

//Output VAO data to Fragment Shader.
out vec3  position;
out vec4  colour;
out vec2  textureCoord;
out float textureIndex;
out float textureTilingFactor;
out vec4  tintColour;

uniform mat4 u_ViewProjectionMatrix;
uniform mat4 u_ModelMatrix;

void main(void)
{
	position            = attrib_Position;
	colour              = attrib_Colour;
	textureCoord        = attrib_TextureCoord;
	textureIndex        = attrib_TextureIndex;
	textureTilingFactor = attrib_TextureTilingFactor;
	tintColour          = attrib_TintColour;

	//Position already transform by transformation on Cpu in C++ code.
	gl_Position = u_ViewProjectionMatrix * vec4(position, 1.0f);
}

#type fragment
#version 330 core

layout (location = 0) out vec4 out_Pixel;

//Input VAO data from Vertex Shader.
in vec3  position;
in vec4  colour;
in vec2  textureCoord;
in float textureIndex;
in float textureTilingFactor;
in vec4  tintColour;

uniform sampler2D u_Textures[32];	
uniform float u_DivideTileX;
uniform float u_DivideTileY;

//Output colour.
uniform vec4 u_Colour;

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
	if     (u_DivideTileX == 1) return vec2(textureCoord.x * textureTilingFactor, textureCoord.y); 
	else if(u_DivideTileY == 1) return vec2(textureCoord.x, textureCoord.y * textureTilingFactor);
	else if(u_DivideTileX == 1 && u_DivideTileY == 1) return textureCoord * textureTilingFactor; 
}

void main(void)
{
	vec4 textureColour = tintColour;
	switch(int(textureIndex))
	{
		case 0: textureColour *= texture(u_Textures[0], tiledTextureCoord()); break;
		case 1: textureColour *= texture(u_Textures[1], tiledTextureCoord()); break;
		case 2: textureColour *= texture(u_Textures[2], tiledTextureCoord()); break;
		case 3: textureColour *= texture(u_Textures[3], tiledTextureCoord()); break;
		case 4: textureColour *= texture(u_Textures[4], tiledTextureCoord()); break;
		case 5: textureColour *= texture(u_Textures[5], tiledTextureCoord()); break;
		case 6: textureColour *= texture(u_Textures[6], tiledTextureCoord()); break;
		case 7: textureColour *= texture(u_Textures[7], tiledTextureCoord()); break;
		case 8: textureColour *= texture(u_Textures[8], tiledTextureCoord()); break;
		case 9: textureColour *= texture(u_Textures[9], tiledTextureCoord()); break;
		case 10: textureColour *= texture(u_Textures[10], tiledTextureCoord()); break;
		case 11: textureColour *= texture(u_Textures[11], tiledTextureCoord()); break;
		case 12: textureColour *= texture(u_Textures[12], tiledTextureCoord()); break;
		case 13: textureColour *= texture(u_Textures[13], tiledTextureCoord()); break;
		case 14: textureColour *= texture(u_Textures[14], tiledTextureCoord()); break;
		case 15: textureColour *= texture(u_Textures[15], tiledTextureCoord()); break;
		case 16: textureColour *= texture(u_Textures[16], tiledTextureCoord()); break;
		case 17: textureColour *= texture(u_Textures[17], tiledTextureCoord()); break;
		case 18: textureColour *= texture(u_Textures[18], tiledTextureCoord()); break;
		case 19: textureColour *= texture(u_Textures[19], tiledTextureCoord()); break;
		case 20: textureColour *= texture(u_Textures[20], tiledTextureCoord()); break;
		case 21: textureColour *= texture(u_Textures[21], tiledTextureCoord()); break;
		case 22: textureColour *= texture(u_Textures[22], tiledTextureCoord()); break;
		case 23: textureColour *= texture(u_Textures[23], tiledTextureCoord()); break;
		case 24: textureColour *= texture(u_Textures[24], tiledTextureCoord()); break;
		case 25: textureColour *= texture(u_Textures[25], tiledTextureCoord()); break;
		case 26: textureColour *= texture(u_Textures[26], tiledTextureCoord()); break;
		case 27: textureColour *= texture(u_Textures[27], tiledTextureCoord()); break;
		case 28: textureColour *= texture(u_Textures[28], tiledTextureCoord()); break;
		case 29: textureColour *= texture(u_Textures[29], tiledTextureCoord()); break;
		case 30: textureColour *= texture(u_Textures[30], tiledTextureCoord()); break;
		case 31: textureColour *= texture(u_Textures[31], tiledTextureCoord()); break;
	}
	
	out_Pixel = colour * textureColour;
	
	//out_Colour = texture(u_Textures[int(textureIndex)], tiledTextureCoord()) * colour * tintColour;
	out_Colour = colour;
}