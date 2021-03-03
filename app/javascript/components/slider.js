import 'nouislider/distribute/nouislider.css';
import noUiSlider from 'nouislider/distribute/nouislider.js';

export const slider = () => {
  const  range = {
      'min': [450],
      '25%': [800],
      '50%': [1100],
      '75%': [1600],
      'max': [2600]
  }
  const slider = document.getElementById('slider');
  noUiSlider.create(slider, {
      start: [450],
      snap: true,
      connect: 'lower',
      range: range,
      pips: {
        mode: 'range',
        density: 3
    }
  });

  const stepSliderValueElement = document.getElementById('slider-step-value');
  const brightness = document.getElementById('brightness');

  slider.noUiSlider.on('update', function (values, handle) {
      stepSliderValueElement.innerHTML = values[handle];
      brightness.value = values[handle];
  });
};