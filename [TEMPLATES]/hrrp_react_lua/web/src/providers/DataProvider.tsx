import { DataContextProps, iClientInfo } from '@/types/DataProviderTypes';
import React from 'react';

import { useNuiEvent } from '@/util/useNuiEvent';
import './debug.g';

export const DataCtx = React.createContext<DataContextProps>({} as DataContextProps);

export const DataProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [ClientInfo, setClientInfo] = React.useState<iClientInfo>({
    hidden: true,
    sniper: false,
    armed: false,
    blindfolded: false,
    persistent: {},
    flashbanged: false,
    isDeathTexts: false,
    isReleasing: false,
    deathTime: -1,
    releaseTimer: -1,
    releaseType: '',
    releaseKey: 'E',
    helpKey: 'E',
    medicalPrice: 100,
  });

  //#region Client Info
  useNuiEvent('APP_SHOW', (data) => {
    setClientInfo((prev: any) => ({
      ...prev,
      hidden: false,
    }));
  });

  useNuiEvent('APP_HIDE', (data) => {
    setClientInfo((prev: any) => ({
      ...prev,
      hidden: true,
    }));
  });

  useNuiEvent('DO_DEATH_TEXT', (data) => {
    setClientInfo((prev: any) => ({
      ...prev,
      isDeathTexts: true,
      isReleasing: false,
      deathTime: data.deathTime * 1000,
      releaseTimer: data.timer * 1000,
      releaseType: data.type,
      releaseKey: data.key,
      helpKey: data.f1Key,
      medicalPrice: data.medicalPrice,
    }));
  });

  useNuiEvent('DO_DEATH_RELEASING', (data) => {
    setClientInfo((prev: any) => ({
      ...prev,
      isReleasing: true,
    }));
  });

  useNuiEvent('HIDE_DEATH_TEXT', (data) => {
    setClientInfo((prev: any) => ({
      ...prev,
      isDeathTexts: false,
      isReleasing: false,
      deathTime: -1,
      releaseTimer: -1,
      releaseType: false,
      releaseKey: false,
      helpKey: false,
      medicalPrice: false,
    }));
  });

  useNuiEvent('SHOW_SCOPE', (data) => {
    setClientInfo((prev: any) => ({
      ...prev,
      sniper: true,
    }));
  });

  useNuiEvent('HIDE_SCOPE', (data) => {
    setClientInfo((prev: any) => ({
      ...prev,
      sniper: false,
    }));
  });

  useNuiEvent('ARMED', (data) => {
    setClientInfo((prev: any) => ({
      ...prev,
      armed: data.state,
    }));
  });

  useNuiEvent('SET_BLINDFOLD', (data) => {
    setClientInfo((prev: any) => ({
      ...prev,
      blindfolded: data.state,
    }));
  });

  useNuiEvent('SET_FLASHBANGED', (data) => {
    setClientInfo((prev: any) => ({
      ...prev,
      flashbanged: data,
    }));
  });

  useNuiEvent('CLEAR_FLASHBANGED', (data) => {
    setClientInfo((prev: any) => ({
      ...prev,
      flashbanged: false,
    }));
  });
  //#endregion

  const value = {
    ClientInfo,
    setClientInfo,
  };

  return <DataCtx.Provider value={value}>{children}</DataCtx.Provider>;
};
