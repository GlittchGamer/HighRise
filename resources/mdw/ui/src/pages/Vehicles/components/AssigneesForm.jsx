import { makeStyles } from '@mui/styles';
import React, { useEffect, useState } from 'react';

import { useSelector } from 'react-redux';
import { Modal, OfficerSearch } from '../../../components';

import Nui from '../../../util/Nui';

const useStyles = makeStyles((theme) => ({
	editorField: {
		marginBottom: 10,
	},
}));

export default ({ open, flagTypes, existing = null, onSubmit, onClose }) => {
	const classes = useStyles();
	const user = useSelector((state) => state.app.user);
	const myJob = useSelector((state) => state.app.govJob);

	const [officers, setOfficers] = useState(Array());
	const [searchInput, setInput] = useState('');
	const [assigned, setAssigned] = useState(Array());

	useEffect(() => {
		if (existing && existing?.length > 0) {
			setAssigned(existing);
		}
	}, [existing]);

	const internalSubmit = (e) => {
		e.preventDefault();
		onSubmit(assigned);
		setInput('');
		setOfficers(Array());
	};

	const onRender = async () => {
		try {
			let res = await (
				await Nui.send('RosterView', {
					job: 'police',
				})
			).json();

			setOfficers(res);
		} catch (err) {
			console.log(err);
		}
	};

	useEffect(() => {
		onRender();
	}, []);

	return (
		<Modal
			open={open}
			maxWidth="sm"
			title="Manage Assigned Drivers"
			submitLang="Update"
			onSubmit={internalSubmit}
			onClose={onClose}
		>
			<OfficerSearch
				job={myJob.Id}
				label={'Assigned Drivers'}
				value={assigned}
				inputValue={searchInput}
				options={officers}
				setOptions={setOfficers}
				onChange={(e, nv) => {
					if (nv.length == 0) {
						setAssigned(Array());
						setInput('');
					} else {
						setAssigned(nv);
						setInput('');
					}
				}}
				onInputChange={(e, nv) => setInput(nv)}
			/>
		</Modal>
	);
};
