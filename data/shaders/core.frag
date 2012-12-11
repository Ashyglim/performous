#ifndef GL_ES
#version 120
#extension GL_ARB_texture_rectangle : require
#endif

//DEFINES

uniform mat4 colorMatrix;

#ifdef ENABLE_BOGUS
in float bogus;  // Workaround for http://www.nvnews.net/vbulletin/showthread.php?p=2401097
#endif

varying vec3 normal;
varying vec4 color;

#ifdef ENABLE_LIGHTING
varying vec3 lightDir;
#endif

#ifdef ENABLE_TEXTURING
varying vec4 texCoord;
#if ENABLE_TEXTURING == 1 && !defined(GL_ES)
uniform sampler2DRect tex;
#define TEXFUNC texture2DRect(tex, texCoord.st)
#elif ENABLE_TEXTURING == 2 || defined(GL_ES)
uniform sampler2D tex;
#define TEXFUNC texture2D(tex, texCoord.st)
#else
#error Unknown texturing mode in ENABLE_TEXTURING
#endif
#endif

#ifndef TEXFUNC
#define TEXFUNC vec4(1,1,1,1)
#endif

void main() {
	vec4 frag = TEXFUNC;

#ifdef ENABLE_BOGUS
	frag.a += 1e-14 * bogus;  // Convince the compiler not to optimize away the bogus variable
#endif

#ifdef ENABLE_VERTEX_COLOR
	frag *= color;
#endif

#ifdef ENABLE_LIGHTING
	vec3 n = normalize(normal);
	vec3 l = normalize(lightDir);

	// Diffuse
	float diff = max(dot(n, l), 0.0);
	float power = 1.0 - 0.02 * length(lightDir);
	frag = vec4(frag.rgb * power * diff, frag.a);
	
#endif

	frag = colorMatrix * frag;  // Colorize

#ifdef ENABLE_LIGHTING

	// Specular
	vec3 refl = reflect(-l, n);
	float spec = dot(refl, n);
	if (power > 0.0) {
		power *= pow(spec, 100.0);
		frag.rgb += vec3(power, power, power);
	}
#endif

	gl_FragColor = frag;
}

