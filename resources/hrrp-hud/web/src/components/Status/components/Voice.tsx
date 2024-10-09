import React from 'react';

interface AudioVisualizerProps {
  talkingOnRadio: boolean;
  talking: boolean;
  audioRange: number;
}

const AudioVisualizer: React.FC<AudioVisualizerProps> = ({ talkingOnRadio, talking, audioRange }) => {
  const voiceRange = Array(3).fill(null);
  const voiceBars = Array(7).fill(null);

  return (
    <div
      className="absolute select-none flex flex-col items-center translate-y-14 -translate-x-2 4k:-translate-y-2 4k:-translate-x-10"
      style={{
        bottom: 250,
        right: 64,
      }}
    >
      <div className="audioBarsWrapper">
        {voiceBars.map((_, index) => (
          <div
            key={index}
            className={`audioBar ${talkingOnRadio ? 'audioRadio' : talking ? 'audioTalking' : ''}`}
            style={{
              maxHeight: audioRange === 1 ? '50%' : audioRange === 2 ? '70%' : undefined,
            }}
          ></div>
        ))}
      </div>
      <div className="audioRangWrapper">
        {voiceRange.map((_, index) => (
          <div key={index} className={`audioRangeBar ${audioRange < index + 1 ? 'audioRangeBar' : 'audioBarActive'}`}></div>
        ))}
      </div>
    </div>
  );
};

export default AudioVisualizer;
