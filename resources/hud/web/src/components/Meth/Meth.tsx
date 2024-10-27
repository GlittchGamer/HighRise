import './Meth.scss';

import { NUI } from '@/util/NUI';
import useKeypress from 'react-use-keypress';
import { Button, Dialog, DialogActions, DialogContent, DialogTitle, Grid, Grid2, Slider, Typography } from '@mui/material';
import useData from '@/hooks/useData';

const IngredientLabel: string[] = ['Acetone', 'Battery Acid', 'Iodine Crystals', 'Sulfuric Acid', 'Phosphorous', 'Gasoline', 'Lithium', 'Anhydrous Ammonia'];

const Meth = () => {
  const { Meth } = useData();

  const onClose = () => {
    NUI.Send('closeMeth');
  };

  const onSubmit = (e) => {
    e.preventDefault();

    let vals = {
      tableId: Meth.config.tableId,
      ingredients: Array(),
      cookTime: +e.target.cooktime.value,
    };

    for (var i = 0; i < Meth.config.ingredients.length; i++) {
      vals.ingredients.push(+(e.target[`ingredient${i}`].value || 0));
    }

    NUI.Send('Meth:Start', vals);
  };

  useKeypress('Escape', onClose);

  const createIngredientSliders = () => {
    let arr = Array();
    Meth.config.ingredients.map((ingredient, i) =>
      arr.push(
        <Grid2 key={`ing-${i}`} columnSpacing={{ xs: 12 }}>
          <Typography id={`ingredient${i}-label`} gutterBottom>
            {IngredientLabel[i]}
          </Typography>
          <Slider step={1} defaultValue={0} valueLabelDisplay="auto" name={`ingredient${i}`} getAriaValueText={(v) => `${v}`} aria-labelledby={`ingredient${i}-label`} />
        </Grid2>,
      ),
    );
    return arr;
  };

  return (
    <Dialog fullWidth maxWidth="sm" open={true} onClose={onClose}>
      <form onSubmit={onSubmit}>
        <DialogTitle>Select Ingredient Mixture</DialogTitle>
        <DialogContent style={{ paddingTop: 15, overflow: 'hidden' }}>
          <Grid2>
            {createIngredientSliders()}
            <Grid2 columnSpacing={{ xs: 12 }}>
              <Typography id={`cooktime-label`} gutterBottom>
                Cook Time (Minutes)
              </Typography>
              <Slider step={1} min={1} max={Meth.config.maxCookTime} defaultValue={1} valueLabelDisplay="auto" name="cooktime" aria-labelledby={`cooktime-label`} />
            </Grid2>
          </Grid2>
        </DialogContent>
        <DialogActions>
          <Button onClick={onClose} color="error">
            Cancel
          </Button>
          <Button type="submit" color="success">
            Submit
          </Button>
        </DialogActions>
      </form>
    </Dialog>
  );
};

export default Meth;
