import { Fade } from '@mui/material';

import './Sniper.scss';
import useData from '@/hooks/useData';

const Sniper = () => {
  const { ClientInfo, Vehicle } = useData();
  return (
    <Fade in={ClientInfo.armed && ClientInfo.sniper && !Vehicle.showing}>
      <div className={'penis'}>
        {/* <img src={FullScope} className={classes.scope} /> */}
        {/* <svg width="100%" height="100%">
                <defs>
                    <mask id="mask" x="0" y="0" width="100%" height="100%">
                        <rect
                            x="0"
                            y="0"
                            width="100%"
                            height="100%"
                            fill="#fff"
                        />
                        <circle cx="50%" cy="50%" r="26.5%" />
                    </mask>
                </defs>
                <rect
                    x="0"
                    y="0"
                    width="100%"
                    height="100%"
                    mask="url(#mask)"
                    fillOpacity="0.8"
                />
            </svg> */}
      </div>
    </Fade>
  );
};

export default Sniper;
