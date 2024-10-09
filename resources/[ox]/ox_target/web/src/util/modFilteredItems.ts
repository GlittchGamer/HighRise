import { Interact } from '@/App';

export const modFilteredItems = (filteredOptions: Interact[], selector: number) => {
  return filteredOptions.length === 1 ? [] : filteredOptions.reduce((acc, Interact, index) => (index % 2 === selector ? [Interact, ...acc] : acc), [] as Interact[]);
};
