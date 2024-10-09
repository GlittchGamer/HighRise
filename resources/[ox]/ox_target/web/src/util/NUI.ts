interface DebugEvent<T = any> {
  event: string;
  data: T;
}

interface NuiMessageData<T = unknown> {
  event: string;
  data: T;
}

type NuiHandlerSignature<T> = (data: T) => void;

export class NUI {
  static async Send<T = any>(eventName: string, data?: any, mockData?: T): Promise<T> {
    const options = {
      method: 'post',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: JSON.stringify(data),
    };

    if (this.isEnvBrowser() && mockData) return mockData;

    const resourceName = (window as any).GetParentResourceName ? (window as any).GetParentResourceName() : 'nui-frame-app';

    const resp = await fetch(`https://${resourceName}/${eventName}`, options);

    const respFormatted = await resp.json();

    return respFormatted;
  }

  static isEnvBrowser(): boolean {
    return !(window as any).invokeNative;
  }

  static Emulate<P>(event: DebugEvent<P>): void {
    if (import.meta.env.MODE === 'development' && this.isEnvBrowser()) {
      window.dispatchEvent(
        new MessageEvent('message', {
          data: {
            event: event.event,
            data: event.data,
          },
        }),
      );
    }
  }
}
