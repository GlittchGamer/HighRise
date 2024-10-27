type Props = {};

import useData from '@/hooks/useData';
import { classNames } from '@/util/misc';
import { faBoltLightning, faEngine, faKey } from '@fortawesome/pro-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import './Vehicle.scss';

const Vehicle = (props: Props) => {
  const { Vehicle } = useData();

  if (!Vehicle.showing) return null;

  const getSpeed = (speed) => {
    return speed.toString().padStart(3, '0');
  };

  const redlineStart = 0.7; // Start of the red zone at 70% of max RPM
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
    <div className="flex h-[21vh] items-end">
      <div className="flex flex-row h-[30%] items-center space-x-2">
        {Vehicle.electricVehicle && (
          <div className="flex flex-col w-6 h-full bg-violet-500/50 rounded-md border border-fuchsia-500 items-center">
            <span className="text-fuchsia-500">
              <FontAwesomeIcon icon={faBoltLightning} />
            </span>
            <div className="relative h-full bg-[#3f2a9e] w-1/3 mb-1 rounded-md">
              <div className="absolute bottom-0 h-1/2 bg-[#623fff] w-full rounded-md"></div>
            </div>
          </div>
        )}
        <div className="flex flex-col">
          <div className="flex flex-col items-start">
            <span
              className="text-xl"
              style={{
                fontFamily: 'Geist-Black',
              }}
            >
              MP/H
            </span>
            <div className="flex flex-row items-center space-x-2">
              <div className="text-4xl grid grid-cols-1" style={{ fontFamily: 'Segment7Standard' }}>
                <p className="mainText text-gray-500">{'8'.repeat(getSpeed(Vehicle.speed) ? getSpeed(Vehicle.speed).length : 3)}</p>
                <p className="mainText">{getSpeed(Vehicle.speed)}</p>
              </div>
              <div
                className="w-8 h-8 rounded-md flex items-center justify-center text-2xl bg-white/15 transition-all"
                style={{ color: getColor(Vehicle.rpm), textShadow: 'black 1px 1px 1px' }}
              >
                {Vehicle.gear}
              </div>
            </div>
          </div>
          <div className="flex flex-row space-x-2 items-center">
            {!Vehicle.fuelHide && (
              <div>
                <FontAwesomeIcon icon={['fas', 'gas-pump']} /> {Vehicle.fuelLevel.toFixed(2)}/{Vehicle.fuelTankCapacity.toFixed(2)}l
              </div>
            )}
            <span className="text-white/70">|</span>
            <div className="flex flex-row space-x-2">
              <FontAwesomeIcon icon={faKey} />
              <FontAwesomeIcon icon={faEngine} className={classNames(Vehicle.checkEngine) && 'text-red-500'} />
              <img width={20} src="seatbelt.svg" alt="seatbelt" style={{ opacity: Vehicle.seatbelt ? 1 : 0.2 }} className={classNames(!Vehicle.seatbelt && 'animate-pulse')} />
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Vehicle;
