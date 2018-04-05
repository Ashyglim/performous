#version 330 core

uniform mat4 projMatrix;
uniform mat4 mvMatrix;
uniform mat3 normalMatrix;
uniform int noteType;
uniform float hitAnim;
uniform float clock;
uniform float scale;
uniform vec2 position;

in vec3 vertPos;
in vec2 vertTexCoord;
in vec3 vertNormal;
in vec4 vertColor;

// Per-vextex for fragment shader (if no geometry shader)
out vec2 texCoord;
out vec3 lightDir;
out vec3 vLightDir;
out vec3 normal;
out vec4 color;

// Per-vertex for geometry shader (if one exists)
out vec2 vTexCoord;
out vec3 vNormal;
out vec4 vColor;

mat4 scaleMat(in float sc) {
	return mat4(sc,  0,  0,  0,
	             0, sc,  0,  0,
	             0,  0, sc,  0,
	             0,  0,  0,  1);
}

mat4 rotMat(in float ang) {
	float ca = cos(ang);
	float sa = sin(ang);
	return mat4(ca, -sa, 0, 0,
	            sa,  ca, 0, 0,
	             0,   0, 1, 0,
	             0,   0, 0, 1);
}

void main() {
	vTexCoord = texCoord = vertTexCoord;
	vNormal = normal = normalMatrix * vertNormal;
	vColor = color = vertColor;
	vLightDir = lightDir;

	mat4 trans = scaleMat(scale);

	// Cursor arrows
	if (noteType == 0) {
		trans *= scaleMat(1.0 - hitAnim * .5);

	// Regular arrows
	} else if (noteType == 1) {
		trans *= scaleMat(1.0 + hitAnim);

	// Holds
	} else if (noteType == 2) {
		trans *= scaleMat(1.0 + hitAnim);

	// Mines
	} else if (noteType == 3) {
		trans *= scaleMat(1.0 + hitAnim);
		float r = radians(mod(clock*360.0, 360.0)); // They rotate!
		trans *= rotMat(r);
	}

	// Glow color for regular arrows or holds
	if (noteType == 1 || noteType == 2) {
		vColor = color = vec4(
		  min(color.r + hitAnim *.5, 1.0),
		  min(color.g + hitAnim *.5, 1.0),
		  min(color.b + hitAnim *.5, 1.0),
		  max(color.a - hitAnim, 0.0)
		);
	}

	gl_Position = projMatrix * mvMatrix * (vec4(position, 0, 0) + trans * vec4(vertPos, 1.0));
}

