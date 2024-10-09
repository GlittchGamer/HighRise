import Location from '@/components/Location/Location';
import { Fade } from '@mui/material';

import Status from '@/components/Status/Status';
import Vehicle from '@/components/Vehicle/Vehicle';
import useData from '@/hooks/useData';
import './Hud.scss';

/*
Our minimap anchor position (x, y, width, height, left_x, right_x, top_y, bottom_y):
0.015000015497208	0.80739834298932	0.14240506223014	0.16260162601626	0.015000015497208	0.15740507772735	0.80739834298932	0.96999996900558	0.000390625	0.00069444444444444

Calculations I made while researching this:

Resolution: 2560x1440: (16:9 | 1,778)
Minimap: 360x256 = 7,111 x 5,625 (14,063% x 17,778%)
Safezone 0.90 = 128x73 = 20 x 19,726 (5% x 5,069%)
Safezone 0.95 = 64x37 = 40 x 38,919 (2,5% x 2,569%)
Safezone 1.00 = 0x0 = 0 x 0 (0% x 0%)
Minimap width / Aspect ratio = ~4

Resolution: 1280x960: (4:3 | 1,333)
Minimap: 240x170 = 5,333 x 5,647 (18,751% x 17,809%)
Safezone 0.90 = 64x48 = 20 x 20 = (5% x 5%)
Minimap width / Aspect ratio = ~4

Minimap width divided by aspect ratio is always ~4
Minimap height seems to be around ~17,8% of screen height
Safezone seems to be 5% of screen size per -0.10 safezone setting

THIS IS NOT TESTED ON ANYTHING WIDER THAN 16:10
I HAVE ABSOLUTELY NO IDEA WHAT THE NATIVES RETURN ON MULTI MONITOR SETUPS (3*1920 x 1080p etc.)

*/

const Hud = () => {
  const { Hud } = useData();
  return (
    <Fade in={Hud.showing}>
      <div className="hud_wrapper">
        <div className="status_box_wrapper flex flex-row items-start align-bottom space-x-2">
          <div className="flex flex-col">
            <Location />
            <Status />
          </div>
          <Vehicle />
        </div>
      </div>
    </Fade>
  );
};

export default Hud;
