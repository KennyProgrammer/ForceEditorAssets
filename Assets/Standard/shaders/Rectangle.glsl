#type vertex
#version 400 core

//VAO data
layout (location = 0) in vec3  attrib_Position;
layout (location = 1) in vec4  attrib_Colour;
layout (location = 2) in vec3  attrib_Normal;
layout (location = 3) in vec2  attrib_TextureCoord;
layout (location = 4) in vec4  attrib_TextureColour;
layout (location = 5) in float attrib_TextureIndex;
layout (location = 6) in float attrib_TextureTilingFactor;


//Output VAO data to Fragment Shader.
out vec3  position;
out vec4  colour;
out vec3  normal;
out vec2  textureCoord;
out vec4  textureColour;
out float textureIndex;
out float textureTilingFactor;


//Output other data to Fragment Shader.
out vec3 fragPosition;

uniform mat4 u_ViewProjectionMatrix;
uniform mat4 u_ModelMatrix;

void main(void)
{
	position            = attrib_Position;
	colour              = attrib_Colour;
	normal              = attrib_Normal;
	textureCoord        = attrib_TextureCoord;
	textureIndex        = attrib_TextureIndex;
	textureTilingFactor = attrib_TextureTilingFactor;
	textureColour       = attrib_TextureColour;

	//Position already transform by transformation on Cpu in C++ code.
	gl_Position = u_ViewProjectionMatrix * vec4(position, 1.0f);
	//Position of the fragment only by model matrix.
	fragPosition = vec3(u_ModelMatrix * vec4(position, 1.0f));
}

#type fragment
#version 400 core

layout (location = 0) out vec4 out_Pixel;

//Input VAO data from Vertex Shader.
in vec3  position;
in vec4  colour;
in vec3  normal;
in vec2  textureCoord;
in vec4  textureColour;
in float textureIndex;
in float textureTilingFactor;

//Input other data from Vertex Shader.
in vec3 fragPosition;

uniform sampler2D u_Textures[32];	
uniform float u_DivideTileX;
uniform float u_DivideTileY;

//Output colour.
uniform vec4 u_Colour;

//Position of view (eye)
uniform vec3 u_CameraPos;

//Lighting
uniform vec2 u_LightPos;
uniform float u_LightAtt;
uniform vec3 u_LightColour;

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

vec4 calcLight()
{
	float intensity = 1.0 / length(position.xy - u_LightPos) * u_LightAtt;
	vec4 lightColour = vec4(u_LightColour, 1.0) * intensity;

	return lightColour;
}

void main(void)
{
	//vec4 light = calcLight();

	//calculate ambient light.
	float ambientPower = 0.1f;
	vec3 ambientLight = ambientPower * u_LightColour;

	//calculate diffuse light.
	vec3 norm = normalize(normal);
	vec3 lightDirection = normalize(vec3(u_LightPos, 1.0f) - fragPosition);
	float diff = max(dot(norm, lightDirection), 0.0);
	vec3 diffuseLight = diff * u_LightColour;

	//calcaulte specular light.
	float specularPower = 0.5f;
	vec3 viewDirection = normalize(u_CameraPos - fragPosition);
	vec3 reflectDirection = reflect(-lightDirection, norm);
	float spec = pow(max(dot(viewDirection, reflectDirection), 0.0), 32);
	vec3 specularLight = specularPower * spec * u_LightColour;

	//mix all lighting toogether to finalLight
	vec3 finalLight = ambientLight + diffuseLight + specularLight;

	vec4 texColour = textureColour;
	switch(int(textureIndex))
	{
		case 0: texColour *= texture(u_Textures[0], tiledTextureCoord()); break;
		case 1: texColour *= texture(u_Textures[1], tiledTextureCoord()); break;
		case 2: texColour *= texture(u_Textures[2], tiledTextureCoord()); break;
		case 3: texColour *= texture(u_Textures[3], tiledTextureCoord()); break;
		case 4: texColour *= texture(u_Textures[4], tiledTextureCoord()); break;
		case 5: texColour *= texture(u_Textures[5], tiledTextureCoord()); break;
		case 6: texColour *= texture(u_Textures[6], tiledTextureCoord()); break;
		case 7: texColour *= texture(u_Textures[7], tiledTextureCoord()); break;
		case 8: texColour *= texture(u_Textures[8], tiledTextureCoord()); break;
		case 9: texColour *= texture(u_Textures[9], tiledTextureCoord()); break;
		case 10: texColour *= texture(u_Textures[10], tiledTextureCoord()); break;
		case 11: texColour *= texture(u_Textures[11], tiledTextureCoord()); break;
		case 12: texColour *= texture(u_Textures[12], tiledTextureCoord()); break;
		case 13: texColour *= texture(u_Textures[13], tiledTextureCoord()); break;
		case 14: texColour *= texture(u_Textures[14], tiledTextureCoord()); break;
		case 15: texColour *= texture(u_Textures[15], tiledTextureCoord()); break;
		case 16: texColour *= texture(u_Textures[16], tiledTextureCoord()); break;
		case 17: texColour *= texture(u_Textures[17], tiledTextureCoord()); break;
		case 18: texColour *= texture(u_Textures[18], tiledTextureCoord()); break;
		case 19: texColour *= texture(u_Textures[19], tiledTextureCoord()); break;
		case 20: texColour *= texture(u_Textures[20], tiledTextureCoord()); break;
		case 21: texColour *= texture(u_Textures[21], tiledTextureCoord()); break;
		case 22: texColour *= texture(u_Textures[22], tiledTextureCoord()); break;
		case 23: texColour *= texture(u_Textures[23], tiledTextureCoord()); break;
		case 24: texColour *= texture(u_Textures[24], tiledTextureCoord()); break;
		case 25: texColour *= texture(u_Textures[25], tiledTextureCoord()); break;
		case 26: texColour *= texture(u_Textures[26], tiledTextureCoord()); break;
		case 27: texColour *= texture(u_Textures[27], tiledTextureCoord()); break;
		case 28: texColour *= texture(u_Textures[28], tiledTextureCoord()); break;
		case 29: texColour *= texture(u_Textures[29], tiledTextureCoord()); break;
		case 30: texColour *= texture(u_Textures[30], tiledTextureCoord()); break;
		case 31: texColour *= texture(u_Textures[31], tiledTextureCoord()); break;
	}
	out_Pixel = colour * texColour * vec4(finalLight, 1.0f);
	
		
	//out_Pixel = texture(u_Textures[int(textureIndex)], tiledTextureCoord()) * colour * texColour * vec4(finalLight, 1.0f);
	//out_Pixel = colour * baseLight * vec4(u_LightColour, 1.0f);
	
}