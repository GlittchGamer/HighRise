export const distance = (pos1: number[], pos2: number[]) => {
    return Math.hypot(pos1[0] - pos2[0], pos1[1] - pos2[1], pos1[2] - pos2[2])
}

export function Delay(ms: number) {
    return new Promise(res => setTimeout(res, ms));
}

export const Random = (min: number, max: number) => {
    return Math.floor(Math.random() * (max - min)) + min;
}

export const hexToRGB = (hex: string) => {
    const r = parseInt(hex.substring(1, 3), 16);
    const g = parseInt(hex.substring(3, 5), 16);
    const b = parseInt(hex.substring(5, 7), 16);

    return [r, g, b];
}

/**
 * Can be used to get a console variable of type `char*`, for example a string.
 * @param varName The console variable to look up.
 * @param default_ The default value to set if none is found.
 * @return Returns the convar value if it can be found, otherwise it returns the assigned `default`.
 */
declare function GetConvar(varName: string, default_: string): string;
export const LOGGER = (...args: any[]) => {
    const convar = GetConvar("core_debug", "false");

    if (convar === "true") {
        console.log(...args);
    }
}