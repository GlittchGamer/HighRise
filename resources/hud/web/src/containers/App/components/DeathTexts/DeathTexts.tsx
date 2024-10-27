import React from 'react';
import ReactMomentCountDown from 'react-moment-countdown';

type Props = {};

import './DeathTexts.scss';
import useData from '@/hooks/useData';

const DeathTexts = (props: Props) => {
  const { ClientInfo } = useData();

  const [force, setForce] = React.useState<number>(Math.random());

  const onEnd = () => {
    setForce(Math.random());
  };

  const getTypeText = () => {
    switch (ClientInfo.releaseType) {
      case 'knockout':
        if (Date.now() > ClientInfo.releaseTimer) {
          if (ClientInfo.isReleasing) {
            return <span>Standing Up...</span>;
          } else {
            return (
              <span>
                Press <span className={'highlight'}>[{ClientInfo.releaseKey}]</span> To Stand Up
              </span>
            );
          }
        } else {
          if (ClientInfo.isReleasing) {
            return <span>Standing Up...</span>;
          } else {
            return (
              <span>
                Unconscious. Can Stand Up In
                <ReactMomentCountDown className={'highlight'} toDate={new Date(ClientInfo.releaseTimer)} onCountdownEnd={onEnd} targetFormatMask="m:ss" />
              </span>
            );
          }
        }
      case 'death':
        if (Date.now() > ClientInfo.releaseTimer) {
          if (ClientInfo.isReleasing) {
            return <span>Respawning...</span>;
          } else {
            return (
              <span>
                Press <span className={'highlight'}>[{ClientInfo.releaseKey}]</span> To Respawn (${ClientInfo.medicalPrice})
                {ClientInfo.deathTime + 1000 * 60 * 2 > Date.now() ? (
                  <small className={'small'}>
                    (Call For Medical Available In{' '}
                    <ReactMomentCountDown className={'smallHighlight'} toDate={new Date(ClientInfo.deathTime + 1000 * 60 * 2)} onCountdownEnd={onEnd} targetFormatMask="m:ss" />)
                  </small>
                ) : (
                  <small className={'small'}>
                    (<span className={'smallHighlight'}>[{ClientInfo.helpKey}]</span> To Call For Medical Assistance)
                  </small>
                )}
              </span>
            );
          }
        } else {
          if (ClientInfo.isReleasing) {
            return <span>Respawning...</span>;
          } else {
            return (
              <span>
                Downed. Respawn Available
                <ReactMomentCountDown className={'highlight'} toDate={new Date(ClientInfo.releaseTimer)} onCountdownEnd={onEnd} targetFormatMask="m:ss" />
                {ClientInfo.deathTime + 1000 * 60 * 2 > Date.now() ? (
                  <small className={'small'}>
                    (Call For Medical Available In{' '}
                    <ReactMomentCountDown className={'smallHighlight'} toDate={new Date(ClientInfo.deathTime + 1000 * 60 * 2)} onCountdownEnd={onEnd} targetFormatMask="m:ss" />)
                  </small>
                ) : (
                  <small className={'small'}>
                    (<span className={'smallHighlight'}>[{ClientInfo.helpKey}]</span> To Call For Medical Assistance)
                  </small>
                )}
              </span>
            );
          }
        }
      case 'hospital':
        if (Date.now() > ClientInfo.releaseTimer) {
          if (ClientInfo.isReleasing) {
            return <span>Getting Up...</span>;
          } else {
            return (
              <span>
                Press <span className={'highlight'}>[{ClientInfo.releaseKey}]</span> To Get Out Of Bed
              </span>
            );
          }
        } else {
          if (ClientInfo.isReleasing) {
            return <span>Getting Up...</span>;
          } else {
            return (
              <span>
                Being Treated
                <ReactMomentCountDown className={'highlight'} toDate={new Date(ClientInfo.releaseTimer)} onCountdownEnd={onEnd} targetFormatMask="m:ss" />
              </span>
            );
          }
        }
      case 'hospital_rp':
        return (
          <span>
            Press <span className={'highlight'}>[{ClientInfo.releaseKey}]</span> To Get Out Of Bed
          </span>
        );
    }
  };

  if (!ClientInfo.isDeathTexts || ClientInfo.releaseTimer <= 0) return <></>;
  return (
    <div key={force} className={'deathTexts_container'}>
      {getTypeText()}
    </div>
  );
};

export default DeathTexts;
