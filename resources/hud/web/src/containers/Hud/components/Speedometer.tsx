import { classNames } from '@/util/misc';
import RadialSeparators from '@/util/RadialSeperators';
import { faEngine } from '@fortawesome/pro-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { buildStyles, CircularProgressbarWithChildren } from 'react-circular-progressbar';
import './Speedo.css';

type Props = {
  speed: number;
  rpm: number;
  fuel: number;
  seatbelt: boolean;
  ignition: boolean;
};

const NoCarClasses = [14, 15, 16];

const Speedometer = (props: Props) => {
  const veh = {
    veh_class: 1,
  };

  const isVehPlane = () => [15, 16].includes(veh.veh_class);
  const isVehBoat = () => [14].includes(veh.veh_class);

  const redlineStart = 1.2; // Start of the red zone at 70% of max RPM
  const getColor = (rpm) => {
    if (rpm <= redlineStart) {
      // Green to Yellow gradient from 0 to redlineStart
      const greenValue = 255;
      const redValue = Math.floor((rpm / redlineStart) * 255);
      return `rgb(${redValue}, ${greenValue}, 0)`;
    } else {
      // Yellow to Red gradient from redlineStart to 1.0
      const redValue = 255;
      const greenValue = Math.floor(255 * (1 - (rpm - redlineStart) / (1 - redlineStart)));
      return `rgb(${redValue}, ${greenValue}, 0)`;
    }
  };

  return (
    <div className="Speedometer translate-y-14 -translate-x-2 4k:-translate-y-2 4k:-translate-x-10" style={{ width: 260 }}>
      <svg style={{ position: 'absolute', width: 0, height: 0 }}>
        <defs>
          <linearGradient id="gradient" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" stopColor="white" />
            <stop offset="100%" stopColor="white" />
          </linearGradient>
          <linearGradient id="gradient2" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" stopColor="#C4FF48" />
            <stop offset="100%" stopColor="#C4FF48" />
          </linearGradient>
        </defs>
      </svg>
      <CircularProgressbarWithChildren
        value={props.fuel}
        circleRatio={0.2}
        maxValue={100}
        strokeWidth={2}
        styles={buildStyles({
          rotation: 0.4,
          trailColor: 'rgba(0, 0, 0, .4)',
          pathColor: '#e70032',
        })}
        counterClockwise
      >
        <RadialSeparators
          circleRatio={0.2}
          rotation={0.22}
          padding={1.05}
          count={6}
          style={{
            background: 'rgba(0, 0, 0, .4)',
            opacity: 0.5,
            width: 3,
            height: 3,
            borderRadius: 9999,
          }}
        />
        <div className="absolute" style={{ width: '93%' }}>
          <CircularProgressbarWithChildren
            className="relative z-10"
            circleRatio={0.8}
            value={props.rpm}
            maxValue={1.75}
            minValue={0.15}
            strokeWidth={4}
            styles={buildStyles({
              strokeLinecap: 'butt',
              rotation: 0.6,
              trailColor: 'rgba(0, 0, 0, .4)',
              pathColor: getColor(props.rpm),
            })}
          >
            <div className="absolute" style={{ width: '86%' }}>
              <CircularProgressbarWithChildren
                className="relative z-10"
                circleRatio={0.8}
                value={props.speed}
                maxValue={200}
                strokeWidth={2}
                styles={buildStyles({
                  rotation: 0.6,
                  trailColor: 'rgba(0, 0, 0, .4)',
                  pathColor: 'url(#gradient2)',
                })}
              >
                {!NoCarClasses.includes(veh.veh_class) && (
                  <>
                    <RadialSeparators
                      circleRatio={0.9}
                      rotation={0.6}
                      padding={0.9}
                      count={10}
                      style={{
                        position: 'relative',
                        zIndex: 10,
                        background: '#fff',
                        width: 3,
                        height: 3,
                        borderRadius: 9999,
                      }}
                    />
                    <RadialSeparators
                      circleRatio={0.9}
                      rotation={0.6}
                      padding={0.83}
                      count={10}
                      number={20}
                      style={{
                        position: 'relative',
                        zIndex: 10,
                        fontSize: 10,
                        fontWeight: 900,
                      }}
                      grtOne
                    />
                  </>
                )}
                <div className="relative w-full h-full flex items-center justify-center">
                  <div
                    className="flex flex-col gap-0.5 items-center relativez z-10"
                    style={{
                      marginTop: !NoCarClasses.includes(veh.veh_class) ? 0 : 80,
                    }}
                  >
                    <h1
                      className="text-center font-extrabold text-white leading-normal"
                      style={{
                        fontSize: !NoCarClasses.includes(veh.veh_class) ? 48 : 30,
                      }}
                    >
                      {props.speed}
                    </h1>
                    <h1 className="text-xs font-extrabold text-white text-center -mt-3">mp/h</h1>
                  </div>
                  {isVehPlane() && <img className="absolute top-1/2 -translate-y-1/2 animate-plane-dial overflow-hidden" src="plane_bg.svg" alt="plane_bg" />}
                  {/* {isVehBoat() && (
                    <img
                      className="absolute top-1/2 overflow-hidden rounded-full transition-transform duration-75 -z-10"
                      style={{
                        transform: `translateY(-50%) rotate(${heading}deg)`,
                        transformOrigin: "center",
                      }}
                      src="images/vehicle_hud/grt_one_boat_bg.svg"
                      alt="boat_bg"
                    />
                  )} */}
                  <div
                    className="absolute top-1/2 -translate-y-1/2 overflow-hidden rounded-full w-full h-full -z-10"
                    style={{
                      backgroundImage: 'linear-gradient(180deg, #000 0.14%, rgba(0, 0, 0, 0.00) 89.89%)',
                    }}
                  />
                </div>
                {!NoCarClasses.includes(veh.veh_class) && (
                  <div className="absolute bottom-0 flex items-center justify-center gap-5 w-full">
                    <FontAwesomeIcon icon={faEngine} className={classNames('text-white')} style={{ opacity: props.ignition ? 1 : 0.15 }} />
                    <img width={20} src="seatbelt.svg" alt="seatbelt" style={{ opacity: props.seatbelt ? 1 : 0.15 }} />
                  </div>
                )}
              </CircularProgressbarWithChildren>
            </div>
          </CircularProgressbarWithChildren>
        </div>
      </CircularProgressbarWithChildren>
    </div>
  );
};

export default Speedometer;
