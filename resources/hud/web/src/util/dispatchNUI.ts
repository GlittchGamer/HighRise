interface DispatchEvent<T = any> {
  action: string;
  data: T;
}

/**
 * Dispatches an event to the NUI layer.
 *
 * @param events - The events you want to dispatch
 */

export const dispatchNUI = (action: string, data?: any) => {
  window.dispatchEvent(
    new MessageEvent('message', {
      data: {
        action: action,
        data: data,
      },
    }),
  );
};
