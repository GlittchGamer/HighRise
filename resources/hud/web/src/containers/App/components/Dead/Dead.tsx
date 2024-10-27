import { Fade } from '@mui/material';
import useData from '@/hooks/useData';

type Props = {};

import './Dead.scss';
const Dead = (props: Props) => {
  const { ClientInfo, Status } = useData();

  return (
    <Fade in={Status.isDead && !ClientInfo.blindfolded} timeout={200}>
      <div className="dead_wrapper" />
    </Fade>
  );
};

export default Dead;
