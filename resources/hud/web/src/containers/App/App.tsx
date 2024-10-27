import './App.css';

import 'react-circular-progressbar/dist/styles.css';

import { library } from '@fortawesome/fontawesome-svg-core';
import { fab } from '@fortawesome/free-brands-svg-icons';
import { fas } from '@fortawesome/pro-solid-svg-icons';

import InfoOverlay from '../../components/InfoOverlay/InfoOverlay';
import Hud from '../Hud/Hud';
import NPCDialog from '@/components/NPCDialog';
import Notifications from '../Notifications/Notifications';

import Dead from './components/Dead/Dead';
import Blindfold from './components/Blindfold/Blindfold';
import DeathTexts from './components/DeathTexts/DeathTexts';
import Flashbang from './components/Flashbang/Flashbang';
import Meth from '@/components/Meth/Meth';
import ListMenu from '@/components/List/List';
import Input from '@/components/Input/Input';
import Progress from '@/components/Progress/Progress';
import Action from '../Action/Action';
import Crosshair from '@/components/Crosshair/Crosshair';
import Sniper from '@/components/SniperScope/Sniper';
import GemTable from '@/components/GemTable/GemTable';
import Arcade from '../Arcade/Arcade';
import Confirm from '@/components/Confirm/Confirm';
import RadialMenu from '@/components/RadialMenu/RadialMenu';
import useData from '@/hooks/useData';

library.add(fab, fas);

function App() {
  const { Meth: MethData, List, Input: InputData, Confirm: ConfirmData, Progression } = useData();

  return (
    <>
      <Dead />
      <Blindfold />
      <DeathTexts />
      <Flashbang />
      <InfoOverlay />
      <Hud />
      <Notifications />
      <Action />
      {MethData.showing && <Meth />}
      {List.showing && <ListMenu />}
      {InputData.showing && <Input />}
      {ConfirmData.showing && <Confirm />}
      {Progression.showing && <Progress />}
      {<RadialMenu />}
      {<Crosshair />}
      {<Sniper />}
      {/* {<GemTable />} */}
      {/* {<Arcade />} */}
      {<NPCDialog />}
    </>
  );
}

export default App;
