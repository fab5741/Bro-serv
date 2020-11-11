const state = {
  show: true,
  tempoHide: false,
  myPhoneNumber: '###-####',
  background: 'background.jpg',
  coque: 'phone.jpg',
  sonido: null,
  zoom: '80%',
  volume: 0.6,
  mouse: true,
  config: {
    reseau: 'Bro mobile',
    useFormatNumberFrance: false,
    apps: [],
    themeColor: '#2A56C6',
    colors: ['#2A56C6'],
    language: {},
  },
  AppsHome: [
    {
      name: 'Phone',
      menuTitle: 'visible',
      icons: '../assets/img/icons_app/call.png',
      color: '#5BC236',
      routeName: 'appels',
      inHomePage: true,
    },
  ],
};

const getters = {
  show: ({ show }) => show,
  tempoHide: ({ tempoHide }) => tempoHide,
  coque: ({ coque }) => coque,
  zoom: ({ zoom }) => zoom,
  AppsHome: ({ AppsHome }) => AppsHome,
};

const actions = {

};

const mutations = {
};

export default {
  state,
  getters,
  actions,
  mutations,
};
