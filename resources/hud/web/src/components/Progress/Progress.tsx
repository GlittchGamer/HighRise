import useInterval from '@/util/useInterval';
import { Fade, Grid, LinearProgress, styled } from '@mui/material';
import React from 'react';

import './Progress.scss';
import useData from '@/hooks/useData';
import { dispatchNUI } from '@/util/dispatchNUI';

const Progress = () => {
  const { Progression } = useData();

  const BorderLinearProgress = styled(LinearProgress)(({ theme }) => ({
    height: 8,
    '&.MuiLinearProgress-colorPrimary': {
      backgroundColor: theme.palette.secondary.dark,
    },
    '& .MuiLinearProgress-bar': {
      borderRadius: 5,
      backgroundColor: Progression.cancelled || Progression.failed ? theme.palette.primary.main : Progression.finished ? theme.palette.success.main : theme.palette.info.main,
    },
  }));

  const [curr, setCurr] = React.useState(0);
  const [fin, setFin] = React.useState(true);
  const [to, setTo] = React.useState<any>(null);

  React.useEffect(() => {
    setCurr(0);
    setFin(true);
    if (to) {
      clearTimeout(to);
    }
  }, [Progression.startTime]);

  React.useEffect(() => {
    return () => {
      if (to) clearTimeout(to);
    };
  }, []);

  React.useEffect(() => {
    if (Progression.cancelled || Progression.finished || Progression.failed) {
      setCurr(0);
      setTo(
        setTimeout(() => {
          setFin(false);
        }, 2000),
      );
    }
  }, [Progression.cancelled, Progression.finished, Progression.failed]);

  const tick = () => {
    if (Progression.failed || Progression.finished || Progression.cancelled) return;

    if (curr + 10 > Progression.duration) {
      dispatchNUI('FINISH_PROGRESS');
    } else {
      setCurr(curr + 10);
    }
  };

  const hide = () => {
    dispatchNUI('HIDE_PROGRESS');
  };

  useInterval(tick, curr > Progression.duration ? null : 10);
  return (
    <Fade in={fin} timeout={100} onExited={hide}>
      <div className={'progress_wrapper'}>
        <Grid container className={'label'}>
          <Grid item xs={6}>
            {Progression.finished ? 'Finished' : Progression.failed ? 'Failed' : Progression.cancelled ? 'Cancelled' : Progression.label}
          </Grid>
          <Grid item xs={6} style={{ textAlign: 'right' }}>
            {!Progression.cancelled && !Progression.finished && !Progression.failed && (
              <small>
                {Math.round(curr / 1000)}s / {Math.round(Progression.duration / 1000)}s
              </small>
            )}
          </Grid>
        </Grid>
        <BorderLinearProgress
          variant="determinate"
          classes={{
            determinate: 'progressbar',
            bar: 'progressbar',
          }}
          value={Progression.cancelled || Progression.finished || Progression.failed ? 100 : (curr / Progression.duration) * 100}
        />
      </div>
    </Fade>
  );
};

export default Progress;
