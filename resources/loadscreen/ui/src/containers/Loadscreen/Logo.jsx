import React from 'react';
import { CircularProgress } from '@material-ui/core';
import { makeStyles } from '@material-ui/styles';
import { Dot } from 'react-animated-dots';
import Typewriter from "typewriter-effect";

const useStyles = makeStyles((theme) => ({
    wrapper: {
        height: 'fit-content',
        width: '55%',
        position: 'absolute',
        top: 0,
        bottom: 0,
        left: 0,
        right: 0,
        margin: 'auto',
        textAlign: 'center',
        fontSize: 30,
        color: '#ffffff',
        zIndex: 1000,
        padding: 36,
    },
    img: {
        maxWidth: 500,
        width: '100%',
    },
    innerBody: {
        marginTop: '500px',
        lineHeight: '250%',
        transform: 'translate(0%, 50%)',
        width: '100%',
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
    dot1: {
        color: '#ff0039',
    },
    dot2: {
        color: '#ffffff',
    },
    dot3: {
        color: '#ff0039',
    },
    '@keyframes blinker': {
        '50%': {
            opacity: 0.3,
        },
    },
    '@keyframes pulse': {
        '0%': {
            transform: 'scale(1)',
        },
        '50%': {
            transform: 'scale(1.2)',
        },
        '100%': {
            transform: 'scale(1)',
        },
    },
    Image: {
        height: '35vh',
        width: '35vh',
        marginTop: '-4%',
        animation: '$pulse 4s infinite',
    },
}));

export default (props) => {
	const classes = useStyles();

	return (
		<div className={classes.wrapper}>
        
            <div className={classes.innerBody}>
			<span className={classes.splashHeader}>
					<Typewriter
						onInit={(typewriter) => {typewriter.typeString(props.name + ', Welcome to HighRiseRP.').start()}}
					/>
				</span>

                <span className={classes.splashTip}>
                    {`Loading Into Server `}
                    <Dot className={classes.dot1}>.</Dot>
                    <Dot className={classes.dot2}>.</Dot>
                    <Dot className={classes.dot3}>.</Dot>
                </span>
            </div>
        </div>
	);
};
