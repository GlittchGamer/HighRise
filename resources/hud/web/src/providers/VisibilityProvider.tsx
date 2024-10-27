import { debugData } from '@/util/debugData';
import { classNames, isEnvBrowser } from '@/util/misc';
import { useNuiEvent } from '@/util/useNuiEvent';
import React, { createContext, useMemo, useState } from 'react';
debugData([{ action: 'ui:setVisible', data: true }]);

export interface VisibilityProviderValue {
  setVisible: (visible: boolean) => void;
  visible: boolean;
}

export const VisibilityCtx = createContext<VisibilityProviderValue>({} as VisibilityProviderValue);

export const VisibilityProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [visible, setVisible] = useState(true);

  useNuiEvent<boolean>('ui:setVisible', setVisible);

  const value = useMemo(() => {
    return {
      visible,
      setVisible,
    };
  }, [visible]);

  return (
    <VisibilityCtx.Provider value={value}>
      <main
        style={{ visibility: visible ? 'visible' : 'hidden' }}
        className={classNames('w-full h-screen', {
          'bg-black/75': isEnvBrowser(),
        })}
      >
        {children}
      </main>
      {isEnvBrowser() && <div className="fixed inset-0 -z-10 bg-cover bg-center" style={{ backgroundImage: 'url(images/miko.png)' }}></div>}
    </VisibilityCtx.Provider>
  );
};
