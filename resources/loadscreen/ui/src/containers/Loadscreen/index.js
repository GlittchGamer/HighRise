import React, { useState } from 'react';
import { LinearProgress, Grid, Paper, Typography, IconButton, Slider, Box } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { useSelector } from 'react-redux';
import ReactPlayer from 'react-player';
import Logo from './Logo';
import video from '././../video.mp4';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

const useStyles = makeStyles((theme) => ({
	background: {
		backgroundColor: '#0f0f0f',
		backgroundSize: 'cover',
		minHeight: '100vh',
		display: 'flex',
		overflow: 'hidden',
		justifyContent: 'center',
		alignItems: 'center',
	},
	backgroundImage: {
		//height: '100vh',
		width: '100vw',
	},
	particles: {
		position: 'absolute',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
		zIndex: 9,
	},
	logo: {
		position: 'absolute',
		width: 'fit-content',
		height: 'fit-content',
		textAlign: 'center',
		top: 0,
		bottom: 0,
		left: 0,
		right: 0,
		margin: 'auto',
		zIndex: 10,
		pointerEvents: 'none',
	},
	logoImg: {
		width: '30%',
	},
	text: {
		color: '#ffffff',
		fontSize: '3em',
		textShadow: '2px 2px 8px rgba(0, 0, 0, 0.5)',
		fontFamily: 'Oswald',
		marginTop: 25,
	},
	hightlight: {
		color: '#ff0039',
	},
	prog: {
		display: 'block',
		width: '100%',
		position: 'absolute',
		bottom: 0,
		left: 0,
		zIndex: 5
	},
	effect: {
		position: 'absolute',
		width: '100%',
		height: '100%',
	},
	bar: {
		height: 10,
		backgroundColor: '#333333'
	},
	dot1: {
		color: '#ff0039',
	},
	dot2: {
		color: '#ffffff',
	},
	dot3: {
		color: '#ff0039',
	},
	information: {
		position: 'absolute',
		bottom: '5.5%',
		right: '1%',
		maxWidth: '25%',
		background: '#141414',
		padding: 10,
		border: `1px solid #01b992`,
		borderRadius: 5,
	},
	informationTitle: {
		fontSize: 18,
		color: '#ff0039',
	},
	informationMessage: {
		padding: 10,
		fontSize: 14,
		color: 'white',
		whiteSpace: 'pre-wrap',
	},
	stageText: {
		position: 'absolute',
		left: '1%',
		bottom: '300%',
	},
	completedStage: {
		color: '#ffffff',
		fontWeight: 'bold',
		fontSize: 20,
		fontFamily: 'Oswald',
		'&::after': {
			color: 'green',
			content: '": COMPLETED,"',
			marginRight: 24,
		},
	},
	currentStage: {
		color: '#ffffff',
		fontWeight: 'bold',
		fontSize: 20,
		fontFamily: 'Oswald',
		'&::after': {
			color: 'red',
			content: '": IN PROGRESS,"',
			marginRight: 24,
		},
	},
	img: {},
	innerBody: {
		lineHeight: '250%',
		transform: 'translate(0%, 50%)',
	},
	splashHeader: {
		fontSize: '2vw',
		display: 'block',
	},
	splashBranding: {
		color: '#ff0039',
	},
	splashTip: {
		fontSize: '1vw',
		animation: '$blinker 1s linear infinite',
	},
	splashTipHighlight: {
		fontWeight: 500,
		color: '#ff0039',
		opacity: 1,
	},
	'@keyframes blinker': {
		'50%': {
			opacity: 0.3,
		},
	},
}));

export default () => {
	const classes = useStyles();

	const test = useSelector((state) => state.load.test);
	const pct = Math.min(test.current / test.total) * 100;
	const completed = useSelector((state) => state.load.completed);
	const current = useSelector((state) => state.load.currentStage);

	const name = useSelector(state => state.load.name);
	const priority = useSelector(state => state.load.priority);
	const priorityMessage = useSelector(state => state.load.priorityMessage);

	

	const [currentVideoIndex, setCurrentVideoIndex] = useState(0);

	const handleEnded = () => {
		setCurrentVideoIndex((prevIndex) => (prevIndex + 1) % videos.length);
	};

	return (
		<div className={classes.background}>
			<Logo name={name} />
			{priority > 0 && priorityMessage && (
				<div className={classes.information}>
					<div className={classes.informationTitle}>
						Total Priority Boosts: <b>{priority}</b>
					</div>
					<div className={classes.informationMessage}>{priorityMessage}</div>
				</div>
			)}
			<div className={classes.prog}>
				<div className={classes.stageText}>
					{Object.keys(completed).map((val) => (
						<span key={val} className={classes.completedStage}>
							{val}
						</span>
					))}
					{current != null ? (
						<span className={classes.currentStage}>{current}</span>
					) : pct >= 100 ? (
						<span className={classes.currentStage}>LOAD_MODELS</span>
					) : null}
				</div>
				<LinearProgress
					className={classes.bar}
					variant="determinate"
					value={pct <= 100 ? pct : 100}
				/>
			</div>
			<div style={{ position: 'relative', width: '100%', height: '100%' }}>
				<ReactPlayer
					url={video}
					width="100%"
					height="100%"
					controls={false}
					loop={false}
					playing
					muted
					//onEnded={handleEnded}
				/>
				<div
					className={classes.overlay}
					style={{
						position: 'absolute',
						top: 0,
						left: 0,
						width: '100%',
						height: '100%',
						backgroundColor: 'rgba(225, 0, 55, 0.5)'
					}}
				/>
			
				
			</div>
		</div>
	);
};
