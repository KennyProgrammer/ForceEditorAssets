#type vertex
#version 400 core

//VAO data
layout (location = 0) in vec3 attrib_Position;
layout (location = 1) in vec2 attrib_TextureCoord;
layout (location = 2) in vec3 attrib_Normal;
//layout (location = 3) in vec3 attrib_Tangent;
//layout (location = 4) in vec3 attrib_Bitangent;

//Output VAO data to Fragment Shader.
out vec3  position;
out vec2  textureCoord;
out vec3  normal;

uniform mat4 u_ModelMatrix;
uniform mat4 u_ViewProjectionMatrix;

void main()
{
    position            = attrib_Position;
	normal              = attrib_Normal;
	textureCoord        = attrib_TextureCoord;

    //Position already transform by transformation on Cpu in C++ code.
    gl_Position = u_ViewProjectionMatrix * u_ModelMatrix * vec4(position, 1.0);
}

#type fragment
#version 400 core

out vec4 out_colour;

//Input VAO data from Vertex Shader.
in vec3 position;
in vec2 textureCoord;
in vec3 normal;

uniform sampler2D normal_texture;

//uniform sampler2D material_texture_diffuse1;
//uniform sampler2D material_texture_diffuse2;
//uniform sampler2D material_texture_diffuse3;
//uniform sampler2D material_texture_specular1;
//uniform sampler2D material_texture_specular2;

void main()
{    
    out_colour = vec4(vec3(gl_FragCoord.z), 1.0f);//texture2D(normal_texture, textureCoord);

    //   out_colour = texture2D(material_texture_diffuse1, textureCoord) +
    //             texture2D(material_texture_diffuse2, textureCoord) + 
    //             texture2D(material_texture_specular1, textureCoord) +
    //             texture2D(material_texture_specular2, textureCoord);
}