varying vec3 vColor;
uniform int uShape;

void main()
{
    // // Color
    gl_FragColor = vec4(vColor, 1.0);
    // draw a circle if shape is 0
	if(uShape == 0 && length(gl_PointCoord-0.5) >= 0.5) discard;
}