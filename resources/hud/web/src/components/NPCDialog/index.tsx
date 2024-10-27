import React from 'react';
import { Button, Zoom } from '@mui/material';
import { NUI } from '@/util/NUI';
import './index.scss';

import useKeypress from 'react-use-keypress';
import useData from '@/hooks/useData';

const NPCDialog: React.FC = () => {
  const { NPCDialog: NPCData } = useData();

  useKeypress(['1', '2', '3', '4', '5', '6', 'Escape'], (event: any) => {
    {
      event.key === '1' && NPCData.buttons[0].data && NUI.Send('NPCResponse', NPCData.buttons[0].data);
    }
    {
      event.key === '2' && NPCData.buttons[1].data && NUI.Send('NPCResponse', NPCData.buttons[1].data);
    }
    {
      event.key === '3' && NPCData.buttons[2].data && NUI.Send('NPCResponse', NPCData.buttons[2].data);
    }
    {
      event.key === '4' && NPCData.buttons[3].data && NUI.Send('NPCResponse', NPCData.buttons[3].data);
    }
    {
      event.key === '5' && NPCData.buttons[4].data && NUI.Send('NPCResponse', NPCData.buttons[4].data);
    }
    {
      event.key === '6' && NPCData.buttons[5].data && NUI.Send('NPCResponse', NPCData.buttons[5].data);
    }
  });

  return (
    <div className="npc_container" style={{ display: NPCData.showing ? '' : 'none' }}>
      <Zoom in={NPCData.showing} timeout={500}>
        <div className="wrapper">
          <div className="header">
            <span className="text">
              <span className="big">{NPCData.firstName}</span> {NPCData.lastName}
            </span>
            <div className="tag">{NPCData.tag}</div>
          </div>

          <div className="textBox">
            <svg className="indicator" width="0.83vh" height="0.83vh" viewBox="0 0 9 9" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M0 0H9L4.5 4.5L0 9V0Z" fill="url(#paint0_radial_3202_976)"></path>
              <defs>
                <radialGradient id="paint0_radial_3202_976" cx="0" cy="0" r="1" gradientUnits="userSpaceOnUse" gradientTransform="translate(4.5 4.5) rotate(45) scale(8.48528)">
                  <stop stopColor="#ff0039"></stop>
                  <stop offset="1" stopColor="#ff0039" stopOpacity="0"></stop>
                </radialGradient>
              </defs>
            </svg>
            <span>{NPCData.description}</span>
          </div>

          <div className="options">
            {NPCData.buttons.map((data, index) => (
              <Button key={index} className="option" variant="contained" color="secondary" onClick={() => NUI.Send('NPCResponse', data.data)}>
                <div className="index">{index + 1}</div>
                {data.label}
              </Button>
            ))}
          </div>
        </div>
      </Zoom>
    </div>
  );
};

export default NPCDialog;
