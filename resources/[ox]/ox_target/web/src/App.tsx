import React, { useState } from 'react';

import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import { IconName, library } from '@fortawesome/fontawesome-svg-core';
import Menus from './components/Menu';

import { fas } from '@fortawesome/pro-solid-svg-icons';
import { faHandPointer } from '@fortawesome/pro-solid-svg-icons/faHandPointer';
import { NUI } from './util/NUI';
import { useNuiEvent } from './util/useNuiEvent';

library.add(fas);

export interface Interact {
  data: {
    distance: number;
    event: string;
    hide: boolean;
    icon: IconName;
    label: string;
    minDist: number;
    target: boolean;
    realName: string;
    resource: string;
    text?: string;
    data?: any[];
  };
  targetType: string;
  targetId: number;
  zoneId: number | null;
}

export interface IZones {
  [key: number]: {
    text: string;
    distance: number;
    realName: string;
    icon: IconName;
    target: boolean;
    event: string;
    label: string;
    data: {
      id: string;
      label: string;
      restrictions: {
        job: {
          id: string;
          onDuty: boolean;
        };
      };
      targeting: {
        icon: IconName;
        poly: {
          l: number;
          coords: {
            x: number;
            y: number;
            z: number;
          };
          options: {
            minZ: number;
            maxZ: number;
            heading: number;
          };
          w: number;
        };
        actionString: string;
      };
      canUseSchematics: boolean;
      location: {
        x: number;
        y: number;
        z: number;
        h: number;
      };
    };
    mainIcon: IconName;
  };
  jobPerms: {
    [key: number]: {
      job: string;
      reqDuty: boolean;
    };
    icon: IconName;
    target: boolean;
    distance: number;
    mainIcon: IconName;
  };
}

NUI.Emulate({
  event: 'setTarget',
  data: {
    options: {
      global: [
        {
          distance: 2,
          event: 'Boosting:Client:StartVin',
          hide: false,
          icon: 'face-mask',
          label: 'Scratch Vin',
          minDist: 2,
          target: true,
          realName: 'Scratch Vin',
          resource: 'prp-base',
          text: 'Scratch Vin',
        },
        {
          data: [],
          distance: 2,
          event: 'Vehicles:Client:StartFueling',
          hide: false,
          icon: 'gas-pump',
          label: 'Fuel zafafifa',
          minDist: 2,
          target: true,
          realName: 'prp-base_cb_2',
          resource: 'prp-base',
        },
        {
          data: [],
          distance: 2,
          event: 'Vehicles:Client:StartJerryFueling',
          hide: true,
          icon: 'gas-pump',
          label: 'Refuel With Petrol Can',
          minDist: 2,
          target: true,
          realName: 'Refuel With Petrol Can',
          resource: 'prp-base',
          text: 'Refuel With Petrol Can',
        },
        {
          data: [],
          distance: 4,
          event: 'Vehicles:Client:StoreVehicle',
          hide: true,
          icon: 'garage-open',
          label: 'Store Vehicle',
          minDist: 4,
          target: true,
          realName: 'Store Vehicle',
          resource: 'prp-base',
          text: 'Store Vehicle',
        },
      ],
    },
    zones: [
      {
        1: {
          text: 'Make Parts',
          distance: 2,
          realName: 'Make Parts',
          icon: 'toolbox',
          target: true,
          event: 'Crafting:Client:OpenCrafting',
          label: 'Make Parts',
          data: {
            id: 'mech-harmony-1',
            label: 'Make Parts',
            restrictions: {
              job: {
                id: 'harmony',
                onDuty: true,
              },
            },
            targeting: {
              icon: 'toolbox',
              poly: {
                l: 1.4,
                coords: {
                  x: 1176.1500244140625,
                  y: 2635.2099609375,
                  z: 37.75,
                },
                options: {
                  minZ: 36.75,
                  maxZ: 39.55,
                  heading: 0,
                },
                w: 3.8,
              },
              actionString: 'Crafting',
            },
            canUseSchematics: false,
            location: {
              x: 1176.1500244140625,
              y: 2635.2099609375,
              z: 37.75,
              h: 0,
            },
          },
          mainIcon: 'toolbox',
        },
        jobPerms: {
          '1': {
            job: 'harmony',
            reqDuty: true,
          },
          icon: 'toolbox',
          target: true,
          distance: 2,
          mainIcon: 'toolbox',
        },
      },
    ],
    icon: 'face-mask',
  },
});

type setTarget = {
  options: {
    global: Interact[];
  };
  zones: IZones[];
};

function App() {
  const [Actions, setActions] = useState<any[]>([]);
  const [isActive, setIsActive] = useState(false);

  useNuiEvent('setTarget', (data: any) => {
    setActions([]);
    for (const action in data.options) {
      data.options[action].forEach((e: any, index: number) => {
        setActions((prev) => [...prev, { data: e, targetType: action, targetId: index + 1, zoneId: null }]);
      });
    }
    if (data.zones) {
      for (let i = 0; i < data.zones.length; i++) {
        data.zones[i].forEach((data: any, index: number) => {
          setActions((prev) => [...prev, { data: data, targetType: 'zones', targetId: index + 1, zoneId: i + 1 }]);
        });
      }
    }
  });

  useNuiEvent('leftTarget', () => {
    setActions([]);
  });

  useNuiEvent('visible', ({ visible }) => {
    setIsActive(visible);
  });

  const filteredOptions = Actions.filter((action) => !action.data.hide);
  return React.useMemo(
    () => (
      <>
        {isActive && (
          <div id="app">
            <div className="app">
              <div className={`selection-eye ${isActive ? 'active' : ''}`}>
                {/* <FontAwesomeIcon icon={EyeIcon} size="2x" /> */}
                <FontAwesomeIcon icon={faHandPointer} size="2x" bounce />
                <Menus items={filteredOptions} />
              </div>
            </div>
          </div>
        )}
      </>
    ),
    [Actions, isActive],
  );
}

export default App;
