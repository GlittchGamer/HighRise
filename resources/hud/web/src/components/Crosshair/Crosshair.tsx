import { Fade, useTheme } from '@mui/material';

import useData from '@/hooks/useData';

import './Crosshair.scss';

const Crosshair = () => {
  const { ClientInfo } = useData();

  const theme = useTheme();

  return (
    <Fade in={ClientInfo.armed && !ClientInfo.sniper}>
      <div
        className={'crosshair'}
        style={{
          background: 'white',
          border: `1px solid ${theme.palette.secondary.dark}`,
        }}
      ></div>
    </Fade>
  );
};

export default Crosshair;
