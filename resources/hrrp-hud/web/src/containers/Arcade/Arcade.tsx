import ReactMomentCountDown from 'react-moment-countdown';

import './Arcade.scss';
import { Fade, Grid, useTheme } from '@mui/material';

const Arcade = () => {
  const theme = useTheme();

  // const dispatch = useDispatch();
  // const showing = useSelector((state: RootState) => state.arcade.showing);
  // const info = useSelector((state: RootState) => state.arcade.matchInfo);
  // const team1 = useSelector((state: RootState) => state.arcade.team1);
  // const team2 = useSelector((state: RootState) => state.arcade.team2);

  return null;

  // return (
  //   <Fade dir="down" in={showing} timeout={500} mountOnEnter unmountOnExit>
  //     <div>
  //       <Grid
  //         container
  //         className={"arcade_wrapper"}
  //         sx={{ background: theme.palette.secondary.dark }}
  //       >
  //         <Grid item xs={3} className={"teamInfo"}>
  //           <div className={"teamname"}>Team 1</div>
  //           <div className={"objective"}>
  //             {team1.current} / {team1.max}
  //           </div>
  //         </Grid>
  //         <Grid item xs={6}>
  //           <div className={"gametype"}>{info.matchLabel}</div>
  //           <div className={"timer"}>
  //             <ReactMomentCountDown
  //               className={"highlight"}
  //               toDate={new Date(info.matchEnd)}
  //               targetFormatMask="m:ss"
  //             />
  //           </div>
  //         </Grid>
  //         <Grid item xs={3} className={"teamInfo"}>
  //           <div className={"teamname"}>Team 2</div>
  //           <div className={"objective"}>
  //             {team2.current} / {team2.max}
  //           </div>
  //         </Grid>
  //       </Grid>
  //     </div>
  //   </Fade>
  // );
};

export default Arcade;
