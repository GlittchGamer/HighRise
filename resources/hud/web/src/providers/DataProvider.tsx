import {
  DataContextProps,
  iAction,
  iClientInfo,
  iConfirm,
  iHud,
  iInfoOverlay,
  iInput,
  iInteraction,
  iList,
  iLocation,
  iMeth,
  iNotification,
  iNPCDialog,
  iProgression,
  iStatus,
  iVehicle,
} from '@/types/DataProviderTypes';
import React from 'react';

import { NUI } from '@/util/NUI';
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

  const [Status, setStatus] = React.useState<iStatus>({
    health: 100,
    armor: 0,
    isDead: false,
    talking: false,
    talkingOnRadio: false,
    audioRange: 1,
    statuses: [],
  });

  //#region Status
  useNuiEvent('SET_DEAD', (data) => {
    setStatus((prev) => ({
      ...prev,
      isDead: data.state,
    }));
  });

  useNuiEvent('UPDATE_HP', (data) => {
    setStatus((prev) => ({
      ...prev,
      health: data.hp,
      armor: data.armor,
    }));
  });

  useNuiEvent('REGISTER_STATUS', (data) => {
    setStatus((prev) => ({
      ...prev,
      statuses: [...prev.statuses, data.status],
    }));
  });

  useNuiEvent('RESET_STATUSES', () => {
    setStatus((prev) => ({
      ...prev,
      statuses: [],
    }));
  });

  useNuiEvent('UPDATE_STATUS', (data) => {
    setStatus((prev) => ({
      ...prev,
      statuses: prev.statuses.map((status) => (status.name === data.status.name ? { ...status, ...data.status } : status)),
    }));
  });

  useNuiEvent('UPDATE_STATUS_VALUE', (data) => {
    setStatus((prev) => ({
      ...prev,
      statuses: prev.statuses.map((status) => (status.name === data.name ? { ...status, value: data.value } : status)),
    }));
  });

  useNuiEvent('UPDATE_STATUSES', (data) => {
    setStatus((prev) => ({
      ...prev,
      statuses: data.statuses,
    }));
  });

  useNuiEvent('UPDATE_VOIP_STATUS', (data) => {
    setStatus((prev) => ({
      ...prev,
      talking: data.talking,
      talkingOnRadio: data.talkingOnRadio,
      audioRange: data.audioRange,
    }));
  });
  //#endregion

  const [InfoOverlay, setInfoOverlay] = React.useState<iInfoOverlay>({
    showing: false,
    info: {
      label: '',
      description: '',
    },
  });

  //#region Info Overlay
  useNuiEvent('SHOW_INFO_OVERLAY', (data) => {
    setInfoOverlay({
      showing: true,
      info: data.info,
    });
  });

  useNuiEvent('CLOSE_INFO_OVERLAY', () => {
    setInfoOverlay({
      showing: false,
      info: {},
    });
  });
  //#endregion

  const [Hud, setHud] = React.useState<iHud>({
    showing: false,
  });

  //#region Hud
  useNuiEvent('SHOW_HUD', () => {
    setHud({ showing: true });
  });

  useNuiEvent('HIDE_HUD', () => {
    setHud({ showing: false });
  });

  useNuiEvent('TOGGLE_HUD', () => {
    setHud((prev) => ({ showing: !prev.showing }));
  });
  //#endregion

  const [Location, setLocation] = React.useState<iLocation>({
    showing: false,
    location: {
      main: 'Alta St',
      cross: 'Forum Dr',
      area: 'Rancho',
      direction: 'W',
    },
    shifted: false,
  });

  //#region Location
  useNuiEvent('TOGGLE_LOC', (data) => {
    setLocation((prev) => ({
      ...prev,
      showing: data.state,
    }));
  });

  useNuiEvent('UPDATE_LOCATION', (data) => {
    setLocation((prev) => ({
      ...prev,
      location: data.location,
    }));
  });

  useNuiEvent('SHIFT_LOCATION', (data) => {
    setLocation((prev) => ({
      ...prev,
      shifted: data.shift,
    }));
  });

  useNuiEvent('SHOW_LOCATION', (data) => {
    setLocation((prev) => ({
      ...prev,
      showing: true,
    }));
  });

  //#endregion

  const [Vehicle, setVehicle] = React.useState<iVehicle>({
    showing: false,
    ignition: false,
    speed: 51,
    rpm: 0.1,
    gear: 4,
    electricVehicle: false,
    seatbelt: false,
    seatbeltHide: false,
    cruise: false,
    checkEngine: false,
    fuelLevel: 100,
    fuelTankCapacity: 100,
    fuelHide: false,
  });

  //#region Vehicle
  useNuiEvent('SHOW_VEHICLE', (data) => {
    setVehicle((prev) => ({
      ...prev,
      showing: true,
      electricVehicle: data.electric || false,
    }));
  });

  useNuiEvent('HIDE_VEHICLE', () => {
    setVehicle((prev) => ({
      ...prev,
      showing: false,
    }));
  });

  useNuiEvent('UPDATE_IGNITION', (data) => {
    setVehicle((prev) => ({
      ...prev,
      ignition: data.ignition,
    }));
  });

  useNuiEvent('UPDATE_SPEED', (data) => {
    setVehicle((prev) => ({
      ...prev,
      speed: data.speed,
    }));
  });

  useNuiEvent('UPDATE_RPM', (data) => {
    setVehicle((prev) => ({
      ...prev,
      rpm: data.rpm,
    }));
  });

  useNuiEvent('UPDATE_GEAR', (data) => {
    setVehicle((prev) => ({
      ...prev,
      gear: data.gear,
    }));
  });

  useNuiEvent('UPDATE_SEATBELT', (data) => {
    setVehicle((prev) => ({
      ...prev,
      seatbelt: data.seatbelt,
    }));
  });

  useNuiEvent('SHOW_SEATBELT', () => {
    setVehicle((prev) => ({
      ...prev,
      seatbeltHide: false,
    }));
  });

  useNuiEvent('HIDE_SEATBELT', () => {
    setVehicle((prev) => ({
      ...prev,
      seatbeltHide: true,
    }));
  });

  useNuiEvent('UPDATE_CRUISE', (data) => {
    setVehicle((prev) => ({
      ...prev,
      cruise: data.cruise,
    }));
  });

  useNuiEvent('UPDATE_ENGINELIGHT', (data) => {
    setVehicle((prev) => ({
      ...prev,
      checkEngine: data.checkEngine,
    }));
  });

  useNuiEvent('UPDATE_FUEL', (data) => {
    setVehicle((prev) => ({
      ...prev,
      fuelLevel: data.fuelData.fuelLevel,
      fuelTankCapacity: data.fuelData.fuelTankCapacity,
      fuelHide: data.fuelHide,
    }));
  });

  useNuiEvent('SHOW_FUEL', () => {
    setVehicle((prev) => ({
      ...prev,
      fuelHide: false,
    }));
  });

  useNuiEvent('HIDE_FUEL', () => {
    setVehicle((prev) => ({
      ...prev,
      fuelHide: true,
    }));
  });

  //#endregion

  const [Notifications, setNotifications] = React.useState<iNotification>({
    runningId: 0,
    notifications: [],
  });

  //#region Notifications
  useNuiEvent('CLEAR_ALERTS', () => {
    setNotifications({
      runningId: 0,
      notifications: [],
    });
  });

  useNuiEvent('ADD_ALERT', (data) => {
    const notifAlreadyExists = Notifications.notifications.some((n) => n._id === data?.notification?._id);
    if (notifAlreadyExists) {
      setNotifications((prev) => ({
        ...prev,
        notifications: prev.notifications.map((n) => {
          if (n._id === data?.notification?._id) {
            return {
              ...n,
              ...data.notification,
            };
          }
          return n;
        }),
      }));
    } else {
      setNotifications((prev) => ({
        ...prev,
        notifications: [
          ...prev.notifications,
          {
            _id: prev.runningId + 1,
            created: Date.now(),
            ...data.notification,
          },
        ],
        runningId: prev.runningId + 1,
      }));
    }
  });

  useNuiEvent('REMOVE_ALERT', (data) => {
    setNotifications((prev) => ({
      ...prev,
      notifications: prev.notifications.filter((n) => n._id !== (data.id ?? data._id)),
    }));
  });

  useNuiEvent('HIDE_ALERT', (data) => {
    setNotifications((prev) => ({
      ...prev,
      notifications: prev.notifications.map((n) => {
        if (n._id === data.id) {
          return { ...n, hide: true };
        }
        return n;
      }),
    }));
  });

  //#endregion

  const [Action, setAction] = React.useState<iAction>({
    showing: false,
    message: 'Press F9 to turn on the vehicle engine',
    // buttons: [],
  });

  //#region Action
  useNuiEvent('SHOW_ACTION', (data) => {
    setAction({
      showing: true,
      message: data.message,
      buttons: data.buttons,
    });
  });

  useNuiEvent('HIDE_ACTION', () => {
    setAction({
      showing: false,
      message: '',
    });
  });
  //#endregion

  const [Meth, setMeth] = React.useState<iMeth>({
    showing: false,
    config: {
      tableId: 0,
      ingredients: [],
      maxCookTime: 1,
    },
  });

  //#region Meth
  useNuiEvent('OPEN_METH', (data) => {
    setMeth({
      showing: true,
      config: data.config,
    });
  });

  useNuiEvent('CLOSE_METH', () => {
    setMeth({
      showing: false,
      config: {
        tableId: 0,
        ingredients: [],
        maxCookTime: 1,
      },
    });
  });
  //#endregion

  const [List, setList] = React.useState<iList>({
    showing: false,
    active: null,
    menus: [],
    stack: [],
  });

  //#region List
  useNuiEvent('SET_LIST_MENU', (data) => {
    setList({
      showing: true,
      active: 'main',
      menus: data.menus,
      stack: [],
    });
  });

  useNuiEvent('CHANGE_MENU', (data) => {
    if (!Boolean(List.menus[data.menu]) || data.menu === List.active) return;
    setList((prev) => ({
      ...prev,
      active: data.menu,
      stack: [...prev.stack, prev.active],
    }));
  });

  useNuiEvent('LIST_GO_BACK', () => {
    setList((prev) => ({
      ...prev,
      active: prev.stack.length > 0 ? prev.stack[prev.stack.length - 1] : 'main',
      stack: prev.stack.slice(0, -1),
    }));
  });

  useNuiEvent('CLOSE_LIST_MENU', () => {
    setList({
      showing: false,
      active: null,
      menus: [],
      stack: [],
    });
  });
  //#endregion

  const [Input, setInput] = React.useState<iInput>({
    showing: false,
    event: null,
    title: null,
    label: null,
    type: null,
    data: null,
    inputs: [],
  });

  //#region Input
  useNuiEvent('SHOW_INPUT', (data) => {
    setInput((prev) => ({
      ...prev,
      showing: true,
      ...data,
      options: data.options ?? {},
    }));
  });

  useNuiEvent('CLOSE_INPUT', () => {
    setInput({
      showing: false,
      event: null,
      title: null,
      label: null,
      type: null,
      data: null,
      inputs: [],
    });
  });
  //#endregion

  const [Confirm, setConfirm] = React.useState<iConfirm>({
    showing: false,
    yes: null,
    no: null,
    data: null,
    title: null,
    description: null,
    denyLabel: null,
    acceptLabel: null,
  });

  //#region Confirm
  useNuiEvent('SHOW_CONFIRM', (data) => {
    setConfirm({
      showing: true,
      ...data,
    });
  });

  useNuiEvent('CLOSE_CONFIRM', () => {
    setConfirm({
      showing: false,
      yes: null,
      no: null,
      data: null,
      title: null,
      description: null,
      denyLabel: null,
      acceptLabel: null,
    });
  });
  //#endregion

  const [Progression, setProgression] = React.useState<iProgression>({
    showing: false,
    label: null,
    duration: 0,
    cancelled: false,
    failed: false,
    finished: false,
    startTime: null,
  });

  //#region Progression
  useNuiEvent('START_PROGRESS', (data) => {
    setProgression({
      showing: true,
      ...data,
      cancelled: false,
      failed: false,
      finished: false,
      startTime: Date.now(),
    });
  });

  useNuiEvent('CANCEL_PROGRESS', () => {
    setProgression((prev) => ({
      ...prev,
      failed: false,
      finished: false,
      cancelled: true,
    }));
  });

  useNuiEvent('FAILED_PROGRESS', () => {
    setProgression((prev) => ({
      ...prev,
      cancelled: false,
      finished: false,
      failed: true,
    }));
  });

  useNuiEvent('FINISH_PROGRESS', () => {
    NUI.Send('Progress:Finish');
    setProgression((prev) => ({
      ...prev,
      failed: false,
      finished: true,
    }));
  });

  useNuiEvent('HIDE_PROGRESS', () => {
    setProgression({
      showing: false,
      label: null,
      duration: 0,
      cancelled: false,
      failed: false,
      finished: false,
      startTime: null,
    });
  });
  //#endregion

  const [Interaction, setInteraction] = React.useState<iInteraction>({
    show: false,
    menuItems: [],
    layer: 0,
  });

  //#region Interaction
  useNuiEvent('SHOW_INTERACTION_MENU', (data) => {
    setInteraction((prev) => ({
      ...prev,
      show: data.toggle,
    }));
  });

  useNuiEvent('SET_INTERACTION_MENU', (data) => {
    setInteraction((prev) => ({
      ...prev,
      layer: data.layer,
    }));
  });

  useNuiEvent('SET_INTERACTION_MENU_ITEMS', (data) => {
    setInteraction((prev) => ({
      ...prev,
      menuItems: data.items.sort((a, b) => a.id - b.id),
    }));
  });

  //#endregion

  const [NPCDialog, setNPCDialog] = React.useState<iNPCDialog>({
    showing: false,
    firstName: '',
    lastName: '',
    tag: '',
    description: '',
    buttons: [],
  });

  //#region NPC Dialog
  useNuiEvent('NPCState', (data) => {
    setNPCDialog({
      ...data,
    });
  });

  useNuiEvent('NPCClose', () => {
    setNPCDialog({
      showing: false,
      firstName: '',
      lastName: '',
      tag: '',
      description: '',
      buttons: [],
    });
  });

  //#endregion

  const value = {
    ClientInfo,
    setClientInfo,
    Status,
    setStatus,
    InfoOverlay,
    setInfoOverlay,
    Hud,
    setHud,
    Location,
    setLocation,
    Vehicle,
    setVehicle,
    Notifications,
    setNotifications,
    Action,
    setAction,
    Meth,
    setMeth,
    List,
    setList,
    Input,
    setInput,
    Confirm,
    setConfirm,
    Progression,
    setProgression,
    Interaction,
    setInteraction,
    NPCDialog,
    setNPCDialog,
  };

  return <DataCtx.Provider value={value}>{children}</DataCtx.Provider>;
};
