(function () {
  'use strict';
  var e = {
      7732: function (e, t, a) {
        var n = a(9963),
          r = a(6252);
        const i = { class: 'app' };
        function o(e, t, a, o, s, c) {
          const l = (0, r.up)('SelectionEye');
          return (
            (0, r.wg)(),
            (0, r.iD)('div', i, [(0, r.Wm)(n.uT, { name: 'fade' }, { default: (0, r.w5)(() => [e.visible ? ((0, r.wg)(), (0, r.j4)(l, { key: 0 })) : (0, r.kq)('', !0)]), _: 1 })])
          );
        }
        var s = a(3907),
          c = a(3577);
        const l = { key: 0, class: 'circle' };
        function p(e, t, a, i, o, s) {
          const p = (0, r.up)('FontAwesomeIcon'),
            u = (0, r.up)('Menu');
          return (
            (0, r.wg)(),
            (0, r.iD)(
              'div',
              { class: (0, c.C_)(['selection-eye', { active: !!this.target }]) },
              [
                (0, r.Wm)(
                  n.uT,
                  { mode: 'out-in', name: 'icon-anim', appear: '' },
                  {
                    default: (0, r.w5)(() => [
                      s.currentIcon ? ((0, r.wg)(), (0, r.j4)(p, { key: 1, icon: `fa-solid fa-${s.currentIcon}` }, null, 8, ['icon'])) : ((0, r.wg)(), (0, r.iD)('div', l)),
                    ]),
                    _: 1,
                  },
                ),
                (0, r.Wm)(u, { type: 'left', items: s.leftItems }, null, 8, ['items']),
                (0, r.Wm)(u, { type: 'right', items: s.rightItems }, null, 8, ['items']),
                (0, r.Wm)(u, { type: 'bottom', items: s.bottomItems }, null, 8, ['items']),
              ],
              2,
            )
          );
        }
        var u = a(7810);
        const d = ['onClick', 'onContextmenu'];
        function m(e, t, a, i, o, s) {
          const l = (0, r.up)('FontAwesomeIcon');
          return (
            (0, r.wg)(),
            (0, r.j4)(
              n.uT,
              { name: 'fade' },
              {
                default: (0, r.w5)(() => [
                  a.items.length
                    ? ((0, r.wg)(),
                      (0, r.j4)(
                        n.W3,
                        { key: 0, name: 'list', tag: 'div', class: (0, c.C_)(['menu', a.type]) },
                        {
                          default: (0, r.w5)(() => [
                            ((0, r.wg)(!0),
                            (0, r.iD)(
                              r.HY,
                              null,
                              (0, r.Ko)(
                                a.items,
                                (e) => (
                                  (0, r.wg)(),
                                  (0, r.iD)(
                                    'div',
                                    {
                                      class: (0, c.C_)(['item', { noHover: o.noHover }]),
                                      onClick: (t) => s.clicked(t, e),
                                      onContextmenu: (t) => s.clicked(t, e),
                                      key: e.targetId + '_' + (e.zoneId ?? 'null'),
                                    },
                                    [(0, r.Wm)(l, { icon: `fa-solid fa-${e.data.icon}` }, null, 8, ['icon']), (0, r.Uk)(' ' + (0, c.zw)(e.data.label), 1)],
                                    42,
                                    d,
                                  )
                                ),
                              ),
                              128,
                            )),
                          ]),
                          _: 1,
                        },
                        8,
                        ['class'],
                      ))
                    : (0, r.kq)('', !0),
                ]),
                _: 1,
              },
            )
          );
        }
        var h = {
            name: 'Menu',
            components: { FontAwesomeIcon: u.GN },
            data() {
              return { noHover: !1 };
            },
            props: { type: String, items: Array },
            methods: {
              async clicked(e, t) {
                e.preventDefault(),
                  (this.noHover = !0),
                  await this.FivemAPI.post('select', [t.targetType, t.targetId, t.zoneId]),
                  setTimeout(() => {
                    this.noHover = !1;
                  }, 100);
              },
            },
          },
          g = a(3744);
        const b = (0, g.Z)(h, [
          ['render', m],
          ['__scopeId', 'data-v-297f4a28'],
        ]);
        var v = b,
          f = {
            name: 'SelectionEye',
            components: { Menu: v, FontAwesomeIcon: u.GN },
            computed: {
              ...(0, s.rn)('os', ['target']),
              ...(0, s.Se)('os', ['options']),
              currentIcon() {
                if (this.target && this.options.length) return this.target.icon;
              },
              filteredOptions() {
                return this.options.filter((e) => !e.data.hide);
              },
              bottomItems() {
                return 1 !== this.filteredOptions.length ? [] : this.filteredOptions;
              },
              rightItems() {
                return this.modFilteredItems(0);
              },
              leftItems() {
                return this.modFilteredItems(1);
              },
            },
            methods: {
              modFilteredItems(e) {
                return 1 === this.filteredOptions.length ? [] : this.filteredOptions.reduce((t, a, n) => (n % 2 === e ? [a, ...t] : t), []);
              },
            },
          };
        const T = (0, g.Z)(f, [
          ['render', p],
          ['__scopeId', 'data-v-606f0e6e'],
        ]);
        var I = T,
          w = {
            components: { SelectionEye: I },
            computed: { ...(0, s.rn)(['isDev']), ...(0, s.rn)('os', ['visible']) },
            mounted() {
              this.isDev && (document.body.style.background = '#3d3d3d');
            },
          };
        const k = (0, g.Z)(w, [['render', o]]);
        var D = k;
        a(7658);
        const R = !1,
          y = {
            visible: R,
            target: R
              ? {
                  event: 'setTarget',
                  options: {
                    global: [],
                  },
                  zones: [],
                }
              : null,
          },
          C = {
            visible({ commit: e }, t) {
              e('SET_VISIBLE', t.state);
            },
            leftTarget({ commit: e }) {
              e('SET_TARGET', null);
            },
            setTarget({ commit: e }, t) {
              e('SET_TARGET', t);
            },
          },
          V = {
            SET_VISIBLE(e, t) {
              e.visible = t;
            },
            SET_TARGET(e, t) {
              e.target = t;
            },
          },
          x = {
            options(e) {
              const t = [];
              for (const a in e.target.options)
                e.target.options[a].forEach((e, n) => {
                  t.push({ data: e, targetType: a, targetId: n + 1, zoneId: null });
                });
              if (e.target?.zones)
                for (let a = 0; a < e.target.zones.length; a++)
                  e.target.zones[a].forEach((e, n) => {
                    t.push({ data: e, targetType: 'zones', targetId: n + 1, zoneId: a + 1 });
                  });
              return t;
            },
          };
        var N = { namespaced: !0, state: y, getters: x, actions: C, mutations: V },
          S = (0, s.MT)({ state: { isDev: !1 }, modules: { os: N } });
        const P = S.state.isDev ? 'https://dev/' : `https://${GetParentResourceName()}/`;
        class O {
          constructor() {
            (this.log = S.state.isDev),
              window.addEventListener('message', (e) => {
                const t = e.data.event;
                void 0 !== t && S.dispatch(`os/${t}`, e.data);
              });
          }
          async postInternal(e, t, a, n = !1) {
            a = void 0 === a ? '{}' : JSON.stringify(a);
            const r = await fetch(e + t, { body: a, method: 'POST' });
            return n ? await r.json() : await r.text();
          }
          async post(e, t, a = !1) {
            return this.postInternal(P, e, t, a);
          }
          async postForResource(e, t, a, n) {
            return this.postInternal(`https://${e}/`, t, a, n);
          }
        }
        var j = new O(),
          E = a(3636),
          A = a(9417),
          F = a(3582);
        E.vI.add(A.mRB, F.mRB);
        const _ = (0, n.ri)(D).use(S);
        _.component('font-awesome-icon', u.GN), (_.config.globalProperties.FivemAPI = j), (_.config.globalProperties.$store = S), _.mount('#app');
      },
    },
    t = {};
  function a(n) {
    var r = t[n];
    if (void 0 !== r) return r.exports;
    var i = (t[n] = { exports: {} });
    return e[n].call(i.exports, i, i.exports, a), i.exports;
  }
  (a.m = e),
    (function () {
      var e = [];
      a.O = function (t, n, r, i) {
        if (!n) {
          var o = 1 / 0;
          for (p = 0; p < e.length; p++) {
            (n = e[p][0]), (r = e[p][1]), (i = e[p][2]);
            for (var s = !0, c = 0; c < n.length; c++)
              (!1 & i || o >= i) &&
              Object.keys(a.O).every(function (e) {
                return a.O[e](n[c]);
              })
                ? n.splice(c--, 1)
                : ((s = !1), i < o && (o = i));
            if (s) {
              e.splice(p--, 1);
              var l = r();
              void 0 !== l && (t = l);
            }
          }
          return t;
        }
        i = i || 0;
        for (var p = e.length; p > 0 && e[p - 1][2] > i; p--) e[p] = e[p - 1];
        e[p] = [n, r, i];
      };
    })(),
    (function () {
      a.d = function (e, t) {
        for (var n in t) a.o(t, n) && !a.o(e, n) && Object.defineProperty(e, n, { enumerable: !0, get: t[n] });
      };
    })(),
    (function () {
      a.g = (function () {
        if ('object' === typeof globalThis) return globalThis;
        try {
          return this || new Function('return this')();
        } catch (e) {
          if ('object' === typeof window) return window;
        }
      })();
    })(),
    (function () {
      a.o = function (e, t) {
        return Object.prototype.hasOwnProperty.call(e, t);
      };
    })(),
    (function () {
      var e = { 143: 0 };
      a.O.j = function (t) {
        return 0 === e[t];
      };
      var t = function (t, n) {
          var r,
            i,
            o = n[0],
            s = n[1],
            c = n[2],
            l = 0;
          if (
            o.some(function (t) {
              return 0 !== e[t];
            })
          ) {
            for (r in s) a.o(s, r) && (a.m[r] = s[r]);
            if (c) var p = c(a);
          }
          for (t && t(n); l < o.length; l++) (i = o[l]), a.o(e, i) && e[i] && e[i][0](), (e[i] = 0);
          return a.O(p);
        },
        n = (self['webpackChunksf_slots'] = self['webpackChunksf_slots'] || []);
      n.forEach(t.bind(null, 0)), (n.push = t.bind(null, n.push.bind(n)));
    })();
  var n = a.O(void 0, [998], function () {
    return a(7732);
  });
  n = a.O(n);
})();
