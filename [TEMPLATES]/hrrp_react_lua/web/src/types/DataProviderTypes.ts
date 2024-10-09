import React from 'react';

export interface iClientInfo {
  hidden: boolean;
  sniper: boolean;
  armed: boolean;
  blindfolded: boolean;
  persistent: Record<string, any>;
  flashbanged: any;
  isDeathTexts: boolean;
  isReleasing: boolean;
  deathTime: number;
  releaseTimer: number;
  releaseType: string;
  releaseKey: string;
  helpKey: string;
  medicalPrice: number;
}

export type DataContextProps = {
  ClientInfo: iClientInfo;
  setClientInfo: React.Dispatch<React.SetStateAction<iClientInfo>>;
};
