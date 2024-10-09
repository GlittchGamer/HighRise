import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useTheme } from '@mui/material';

type Props = {};

import useData from '@/hooks/useData';
import './Status.scss';

const demoStatus = [
  {
    options: {
      hideZero: true,
    },
    flash: false,
    name: 'godmode',
    color: '#FFBB04',
    max: 100,
    icon: 'shield-quartered',
    value: 0,
  },
  {
    options: {
      hideHigh: true,
    },
    flash: true,
    name: 'oxygen',
    color: '#457F88',
    max: 100,
    icon: 'lungs',
    value: 100,
  },
  {
    options: {
      noReset: true,
      hideZero: true,
      inverted: true,
      id: 4,
    },
    flash: false,
    name: 'PLAYER_STRESS',
    color: '#de3333',
    max: 0,
    icon: 'face-explode',
    value: 0,
  },
  {
    options: {
      noReset: true,
      hideZero: true,
      inverted: true,
      id: 5,
    },
    flash: false,
    name: 'PLAYER_DRUNK',
    color: '#9D4C0B',
    max: 0,
    icon: 'champagne-glasses',
    value: 0,
  },
];

const Status = (props: Props) => {
  const theme = useTheme();

  const { Status } = useData();

  const elements = Status.statuses
    .sort((a, b) => a.options.id - b.options.id)
    .map((status, i) => {
      if ((status.value >= 90 && status?.options?.hideHigh) || (status.value == 0 && status?.options?.hideZero) || (Status.isDead && !status?.options?.visibleWhileDead))
        return null;

      return (
        <div key={`status-${i}`} className="stat">
          <div className="statBarBase">
            <div
              className="statBar"
              style={{ height: `${status.value}%`, backgroundColor: status.color ? status.color : theme.palette.text.primary, boxShadow: `0 0 0.5vh ${status.color}` }}
            ></div>
          </div>
          <FontAwesomeIcon className="barIcon" icon={status.icon ?? 'question'} />
        </div>
      );
    });

  // console.log(Status.statuses);

  const hungerData = Status.statuses.find((status) => status.name === 'PLAYER_HUNGER');
  const thirstData = Status.statuses.find((status) => status.name === 'PLAYER_THIRST');

  return (
    <div
      className="flex flex-col"
      style={{
        width: '29vh',
      }}
    >
      <div className="flex flex-row">
        <div className="barWrapper border-2 border-black">
          <div className="barBase">
            <div className="healthbar" style={{ width: `${Status.health}%` }} />
          </div>
        </div>
        <div className="barWrapper border-2 border-black border-l-0 border-r-0">
          <div className="barBase">
            <div className="armorbar" style={{ width: `${Status.armor || 100}%` }} />
          </div>
        </div>
        <div className="barWrapper border-2 border-black border-r-0">
          <div className="barBase">
            <div className="plainbar" style={{ width: `${hungerData?.value || 100}%`, backgroundColor: '#ed9e28' }} />
          </div>
        </div>
        <div className="barWrapper border-2 border-black">
          <div className="barBase">
            <div className="plainbar" style={{ width: `${thirstData?.value || 100}%`, backgroundColor: '#07bdf0' }} />
          </div>
        </div>
      </div>
    </div>
    // <div className="hud_wrapper">
    //   <div className="leftDiv">
    //     <div className="barsWrapper">
    //       <div className="wasteWrapper">
    //         {Status.armor > 0 && GetArmor()}
    //         {GetHealth()}
    //         <div className="statWrapper">{elements}</div>
    //       </div>
    //     </div>
    //   </div>
    //   <div className="rightDiv">
    //     <AudioVisualizer talking={Status.talking} talkingOnRadio={Status.talkingOnRadio} audioRange={Status.audioRange} />
    //   </div>
    // </div>
  );
};

export default Status;
