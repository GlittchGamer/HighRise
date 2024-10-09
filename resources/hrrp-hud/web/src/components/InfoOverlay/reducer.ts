export const initialState = {
  showing: false,
  info: Object({
    label: "Hello",
    description: "Hello<br>Hello",
  }),

  // showing: false,
  // info: {
  //     label: "Hello",

  //     description: "Hello<br>Hello"
  // }
};

const infoOverlayReducer = (state = initialState, action) => {
  switch (action.type) {
    case "SHOW_INFO_OVERLAY":
      return {
        ...state,
        showing: true,
        info: action.payload.info,
      };
    case "CLOSE_INFO_OVERLAY":
      return {
        ...state,
        showing: false,
      };
    default:
      return state;
  }
};

export default infoOverlayReducer;
