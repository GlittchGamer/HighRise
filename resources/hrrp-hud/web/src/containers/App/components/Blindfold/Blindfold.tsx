import { Fade } from '@mui/material';

type Props = {};

import './Blindfold.scss';
import useData from '@/hooks/useData';

const Blindfold = (props: Props) => {
  const { ClientInfo } = useData();

  return (
    <Fade in={ClientInfo.blindfolded} timeout={200}>
      <div className="blindfold_wrapper" />
    </Fade>
  );
};

export default Blindfold;
