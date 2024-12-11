<script setup>
import { TresCanvas } from '@tresjs/core'
import { OrbitControls } from '@tresjs/cientos'
import { BasicShadowMap, SRGBColorSpace, NoToneMapping, Color, AdditiveBlending, BufferAttribute } from 'three'
import { ref, onMounted, onUnmounted } from 'vue';

import vertexShader from './shaders/vertex.glsl?raw'
import fragmentShader from './shaders/fragment.glsl?raw'

const pointPositions = ref(null);
const bufferRef = ref(null);

const parameters = {
  count: 1000000,
  size: 5,
}

const numPoints = parameters.count;
const positions = new Float32Array(numPoints * 3); // x, y, z for each point
const colors = new Float32Array(numPoints * 3); // r, g, b for each point
const scales = new Float32Array(numPoints);
let scaler = 2;
for (let i = 0; i < numPoints; i++) {
  positions[i * 3] = (Math.random() - 0.5) * scaler; // x
  positions[i * 3 + 1] = (Math.random() - 0.5) * scaler; // y
  // positions[i * 3 + 2] = (Math.random() - 0.5) * scaler; // z
  colors[i * 3] = Math.random(); // r
  colors[i * 3 + 1] = Math.random(); // g
  colors[i * 3 + 2] = Math.random(); // b
  scales[i] = Math.random();
}
pointPositions.value = positions;
// console.log('pointPositions', pointPositions.value);
console.log("loaded");

const angle2rad = (angle) => (angle * Math.PI) / 180;

const shader = {
  transparent: true,
  depthWrite: false,
  // blending: AdditiveBlending,
  vertexColors: true,
  vertexShader,
  fragmentShader,
  uniforms: {
    uSize: {
      value: parameters.size,
    },
    uShape: { value: 0 },
  },
}

// Use plain variables instead of Vue's state management
let isMouseDown = false;
let mousePosition = [0, 0];

const onMouseMove = (event) => {
  if (isMouseDown) {
    const rect = event.target.getBoundingClientRect();
    const x = ((event.clientX - rect.left) / rect.width) * 2 - 1;
    const y = -((event.clientY - rect.top) / rect.height) * 2 + 1;
    mousePosition = [x, y];
    console.log('Mouse position (NDC):', mousePosition);
  }
};

const onMouseDown = () => {
  isMouseDown = true;
};

const onMouseUp = () => {
  isMouseDown = false;
};

onMounted(() => {
  const canvas = document.querySelector('canvas');
  if (canvas) {
    canvas.addEventListener('mousemove', onMouseMove);
    canvas.addEventListener('mousedown', onMouseDown);
    canvas.addEventListener('mouseup', onMouseUp);
  }
});

onUnmounted(() => {
  const canvas = document.querySelector('canvas');
  if (canvas) {
    canvas.removeEventListener('mousemove', onMouseMove);
    canvas.removeEventListener('mousedown', onMouseDown);
    canvas.removeEventListener('mouseup', onMouseUp);
  }
});

</script>

<template>
  <TresCanvas>
    window-size
    <TresOrthographicCamera 
    :args="[-1, 1, 1, -1, 0.1, 1000]" :manual="true" :position="[0, 0, 1]"/>
    <!-- <TresPerspectiveCamera :position="[0, 10, 10]" :lookAt="[0, 0, 0]" /> -->

    <!-- Point Cloud -->
    <TresPoints ref="bufferRef">
      <TresBufferGeometry
          :position="[pointPositions, 3]"
          :a-scale="[scales, 1]"
          :color="[colors, 3]"
        />
      <TresShaderMaterial v-bind="shader" />
    </TresPoints>

    <!-- Helpers -->
    <TresGridHelper :args="[2, 1]" :rotation="[angle2rad(90), 0, 0]" />

    <!-- Controls -->
    <OrbitControls :enable-pan="true" :enable-rotate="false"/>

  </TresCanvas>
</template>

<style>
html,
body {
  margin: 0;
  padding: 0;
  height: 100%;
  width: 100%;
  background-color: white;
}
#app {
  height: 100%;
  width: 100%;
}
</style>
