interface DebugEvent<T = any> {
  action: string;
  data: T;
}

export class NUI {
  static async Send<T = any>(
    eventName: string,
    data?: any,
    mockData?: T
  ): Promise<T> {
    const options = {
      method: "post",
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: JSON.stringify(data),
    };

    if (this.isEnvBrowser() && mockData) return mockData;

    const resourceName = (window as any).GetParentResourceName
      ? (window as any).GetParentResourceName()
      : "nui-frame-app";

    const resp = await fetch(`https://${resourceName}/${eventName}`, options);

    const respFormatted = await resp.json();

    return respFormatted;
  }

  static isEnvBrowser(): boolean {
    return !(window as any).invokeNative;
  }

  static Emulate<P>(events: DebugEvent<P>[], timer = 1000): void {
    if (import.meta.env.MODE === "development" && this.isEnvBrowser()) {
      for (const event of events) {
        setTimeout(() => {
          window.dispatchEvent(
            new MessageEvent("message", {
              data: {
                action: event.action,
                data: event.data,
              },
            })
          );
        }, timer);
      }
    }
  }
}
