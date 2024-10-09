import { type ClassValue, clsx } from 'clsx';
import { twMerge } from 'tailwind-merge';

import DOMPurify from 'dompurify';
import parse from 'html-react-parser';

export const Sanitize = (html) => {
  return parse(DOMPurify.sanitize(html));
};

export function classNames(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

export const noop = (): void => {};

/**
 * Will return whether the current environment is in a regular browser and not CEF.
 * @returns {boolean} True if the environment is a regular browser, false if CEF.
 */
export const isEnvBrowser = (): boolean => !(window as any).invokeNative;
