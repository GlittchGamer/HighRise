import { List, Slide } from '@mui/material';
import CustomListItem from './components/ListItem';

type Props = {};

import './InfoOverlay.scss';
import useData from '@/hooks/useData';

const InfoOverlay = (props: Props) => {
  const { InfoOverlay } = useData();
  return (
    <Slide direction="down" in={InfoOverlay.showing} timeout={100} mountOnEnter unmountOnExit>
      <div className="InfoOverlay_wrapper">
        <List className="list">
          <CustomListItem label={InfoOverlay.info.label ?? ''} description={InfoOverlay.info?.description ?? ''} disabled={InfoOverlay.info?.disabled ?? true} />
        </List>
      </div>
    </Slide>
  );
};

export default InfoOverlay;
