import React from 'react';

import { Fade, useTheme } from '@mui/material';
import './RadialMenu.scss';

import PieMenu, { background, Slice } from 'react-pie-menu';

import useData from '@/hooks/useData';
import { NUI } from '@/util/NUI';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { debounce } from 'lodash';
import useKeypress from 'react-use-keypress';
import { css, ThemeProvider } from 'styled-components';

const RadialMenu = () => {
  const theme = useTheme();

  const { Interaction } = useData();

  const pieTheme = {
    pieMenu: {
      center: css`
        //border: 2px solid ${theme.palette.secondary.dark};
      `,
    },
    slice: {
      container: css`
        color: white;
        ${background(`${theme.palette.secondary.main}cc`)};
        z-index: 1;

        &::before {
          position: absolute;
          content: '';
          top: 0;
          right: 0;
          bottom: 0;
          left: 0;
          z-index: -1;
          ${background(`${theme.palette.secondary.dark}`)}
          transition: opacity 0.2s ease-out;
          opacity: 0;
        }

        &:hover,
        &[_highlight='true'] {
          ${background(`${theme.palette.secondary.main}cc`)};
        }

        &:hover::before {
          opacity: 1;
        }
      `,
      contentContainer: css`
        font-size: 0.75rem;
      `,
    },
  };

  useKeypress(['F1', 'Escape'], () => {
    if (!Interaction.show) return;
    else NUI.Send('Interaction:Hide');
  });

  //Yes this is stupid, i dont know why the lib fires onClick twice?
  const trigger = debounce(function (item) {
    NUI.Send('Interaction:Trigger', item);
  }, 0);

  const back = async () => {
    if (Interaction.layer === 0) return await NUI.Send('Interaction:Hide');
    await NUI.Send('Interaction:Back');
  };

  const genItems = React.useCallback((items: any) => {
    return items
      .sort((a, b) => (a.id < b.id ? -1 : a.id > b.id ? 1 : 0))
      .map((item) => {
        return (
          <Slice
            key={item.id}
            className={'slice'}
            onSelect={() => {
              trigger(item);
            }}
          >
            {item.label && (
              <div>
                <span className={'label'}>{item.label}</span>
              </div>
            )}
            <FontAwesomeIcon icon={item.icon ?? 'question'} size="2x" />
          </Slice>
        );
      });
  }, []);

  // const huh = 360 / Interaction.menuItems.length || 360;
  return React.useMemo(
    () => (
      <Fade in={Interaction.show} timeout={100}>
        <div className={'div'}>
          <ThemeProvider theme={pieTheme}>
            <PieMenu radius="250px" centerradius="3vw">
              {genItems(Interaction.menuItems)}
            </PieMenu>
            <div className={'back'} onClick={back}>
              {Interaction.layer === 0 && <FontAwesomeIcon icon={'circle-xmark'} />}
              {Interaction.layer !== 0 && <FontAwesomeIcon icon={'circle-arrow-left'} />}
            </div>
          </ThemeProvider>
        </div>
      </Fade>
    ),
    [Interaction.show, Interaction.layer, Interaction.menuItems, genItems],
  );
};

// const RadialMenu = () => {
//   const showing = useSelector((state: RootState) => state.interaction.show);

//   const menuItems = useSelector((state: RootState) => state.interaction.menuItems);
//   const layer = useSelector((state: RootState) => state.interaction.layer);

//   const [hoveredItem, setHoveredItem] = React.useState(null);

//   const trigger = debounce(function (item) {
//     NUI.Send('Interaction:Trigger', item);
//   }, 0);

//   const genItems = () => {
//     return menuItems
//       .sort((a, b) => (a.id < b.id ? -1 : a.id > b.id ? 1 : 0))
//       .map((item) => {
//         return (
//           <li key={item.id} onMouseEnter={() => setHoveredItem(item)} onMouseLeave={() => setHoveredItem(null)} onClick={trigger(item)}>
//             <a className="">
//               <FontAwesomeIcon icon={item.icon ?? 'question'} size="2x" />
//             </a>
//           </li>
//         );
//       });
//   };

//   return (
//     <Fade in={showing} timeout={100}>
//       <div className={'div'}>
//         <ul id="options-wrapper">{genItems()}</ul>
//         <div className="text-2xl">{hoveredItem ? hoveredItem.label : 'Menu'}</div>
//       </div>
//     </Fade>
//   );
// };

export default RadialMenu;
