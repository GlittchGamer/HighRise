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

export interface iStatus {
  health: number;
  armor: number;
  isDead: boolean;
  talking: boolean;
  talkingOnRadio: boolean;
  audioRange: number;
  statuses: Array<any>; // Replace with the appropriate type for statuses
}

export interface iInfoOverlay {
  showing: boolean;
  info: {
    label?: string;
    description?: string;
    disabled?: boolean;
  };
}

export interface iHud {
  showing: boolean;
}

export interface iLocation {
  showing: boolean;
  location: {
    main: string;
    cross: string;
    area: string;
    direction: string;
  };
  shifted: boolean;
}

export interface iVehicle {
  showing: boolean;
  ignition: boolean;
  speed: number;
  gear: number;
  rpm: number;
  seatbelt: boolean;
  seatbeltHide: boolean;
  cruise: boolean;
  checkEngine: boolean;
  electricVehicle: boolean;
  fuelLevel: number;
  fuelTankCapacity: number;
  fuelHide: boolean;
}

export type Notifications = {
  _id: number;
  created: number;
  icon: string;
  message: string;
  duration: number;
  type: string;
  style: any;
  hide: boolean;
};

export interface iNotification {
  runningId: number;
  notifications: Notifications[];
}

export interface iAction {
  showing: boolean;
  message: string;
  buttons?: any; // Replace with the appropriate type for buttons
}

export interface iMeth {
  showing: boolean;
  config: {
    tableId: number;
    ingredients: number[];
    maxCookTime: number;
  };
}

type ListMenuItem = {
  label: string;
  description: string;
  event?: string;
  submenu?: string;
  actions?: Array<{ icon: string; event: string }>;
  disabled?: boolean;
};

export interface iList {
  showing: boolean;
  active: null | string;
  menus: Array<ListMenuItem>; // Replace with the appropriate type for menus
  stack: Array<string>; // Replace with the appropriate type for stack
}

export interface iInput {
  showing: boolean;
  event: string | null;
  title: string | null;
  label: string | null;
  type: string | null;
  data: any | null;
  inputs: Array<{
    id: string;
    type: string;
    options: {
      inputProps: {
        maxLength: number;
      };
    };
  }>;
}

// showing: false,
// yes: null,
// no: null,
// data: null,
// title: null,
// description: null,
// denyLabel: null,
// acceptLabel: null,

export interface iConfirm {
  showing: boolean;
  yes: null | string;
  no: null | string;
  data: any | null;
  title: null | string;
  description: null | string;
  denyLabel: null | string;
  acceptLabel: null | string;
}

export interface iProgression {
  showing: boolean;
  label: null | string;
  duration: number;
  cancelled: boolean;
  failed: boolean;
  finished: boolean;
  startTime: null | number;
}

export type iInteractionItem = {
  id: number;
  label: string;
  icon: any;
  action: string;
};

export interface iInteraction {
  show: boolean;
  menuItems: Array<iInteractionItem>; // Replace with the appropriate type for menuItems
  layer: number;
}

export interface iNPCDialog {
  showing: boolean;
  firstName: string;
  lastName: string;
  tag: string;
  description: string;
  buttons: Array<{ label: string; data: string }>;
}

export type DataContextProps = {
  // isSettingsOpen: boolean;
  // setSettingsOpen: React.Dispatch<React.SetStateAction<boolean>>;
  ClientInfo: iClientInfo;
  setClientInfo: React.Dispatch<React.SetStateAction<iClientInfo>>;
  Status: iStatus; // Replace with the appropriate type
  setStatus: React.Dispatch<React.SetStateAction<iStatus>>;
  InfoOverlay: iInfoOverlay;
  setInfoOverlay: React.Dispatch<React.SetStateAction<iInfoOverlay>>;
  Hud: iHud;
  setHud: React.Dispatch<React.SetStateAction<iHud>>;
  Location: iLocation;
  setLocation: React.Dispatch<React.SetStateAction<iLocation>>;
  Vehicle: iVehicle;
  setVehicle: React.Dispatch<React.SetStateAction<iVehicle>>;
  Notifications: iNotification;
  setNotifications: React.Dispatch<React.SetStateAction<iNotification>>;
  Action: iAction;
  setAction: React.Dispatch<React.SetStateAction<iAction>>;
  Meth: iMeth;
  setMeth: React.Dispatch<React.SetStateAction<iMeth>>;
  List: iList;
  setList: React.Dispatch<React.SetStateAction<iList>>;
  Input: iInput;
  setInput: React.Dispatch<React.SetStateAction<iInput>>;
  Confirm: iConfirm;
  setConfirm: React.Dispatch<React.SetStateAction<iConfirm>>;
  Progression: iProgression;
  setProgression: React.Dispatch<React.SetStateAction<iProgression>>;
  Interaction: iInteraction;
  setInteraction: React.Dispatch<React.SetStateAction<iInteraction>>;
  NPCDialog: iNPCDialog;
  setNPCDialog: React.Dispatch<React.SetStateAction<iNPCDialog>>;
};
