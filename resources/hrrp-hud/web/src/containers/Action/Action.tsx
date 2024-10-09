import './Action.scss';

import { Grow } from '@mui/material';
import ReactHtmlParser from 'react-html-parser';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import useData from '@/hooks/useData';

const Action = () => {
  const { Action } = useData();

  const ParseButtonText = () => {
    let v = Action.message;
    v = v.replace(/\{key\}/g, `<span class='key'}>`);

    v = v.replace(/\{\/key\}/g, `</span>`);

    return v;
  };

  if (!Action.showing) return null;
  return (
    <Grow in={Action.showing}>
      <div className={'action_wrapper'}>
        {ReactHtmlParser(ParseButtonText())}
        <FontAwesomeIcon icon="circle-info" />
      </div>
    </Grow>
  );
};

export default Action;
