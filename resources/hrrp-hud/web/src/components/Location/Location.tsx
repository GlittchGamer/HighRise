import useData from '@/hooks/useData';

import './Location.scss';

const Location = () => {
  const { Location: LocationData } = useData();

  const { ClientInfo, Vehicle } = useData();

  if (ClientInfo.blindfolded) return null;

  if (!Vehicle.showing) return null;

  return (
    <div className="mapborder square flex flex-col justify-between border-4">
      <div className="flex flex-row justify-between p-1 text-xl 2k:text-2xl uppercase text-accent textShadow">
        <div className="flex flex-col items-start">
          <span>{LocationData.location.direction}</span>
          <span>{LocationData.location.main}</span>
          {/* {LocationData.location.cross !== '' && <span>{LocationData.location.cross}</span>} */}
        </div>
      </div>

      <div className="flex flex-row justify-between p-1 text-xl 2k:text-2xl uppercase text-accent textShadow">
        <div className="flex flex-col items-end text-base 2k:text-xl">
          <span>{LocationData.location.area}</span>
        </div>
      </div>
    </div>
    // <div className="location">
    //   {Vehicle.showing && (
    //     <div className="locationMain">
    //       <div className="ItemContainer">
    //         <span className="highlight">
    //           <FontAwesomeIcon icon={faCompass} />
    //         </span>
    //         {LocationData.location.direction}
    //       </div>
    //       <div className="ItemContainer">
    //         <span className="highlight">
    //           <FontAwesomeIcon icon={faLocationDot} />
    //         </span>
    //         {LocationData.location.main}
    //         {LocationData.location.cross !== '' && (
    //           <>
    //             <span className={'highlight'}>x</span>
    //             <span>{LocationData.location.cross}</span>
    //           </>
    //         )}
    //       </div>
    //       <div className="ItemContainer">
    //         <span className="highlight">
    //           <FontAwesomeIcon icon={faMapLocationDot} />
    //         </span>
    //         {LocationData.location.area}
    //       </div>
    //     </div>
    // )}
    // </div>
  );
};

export default Location;
