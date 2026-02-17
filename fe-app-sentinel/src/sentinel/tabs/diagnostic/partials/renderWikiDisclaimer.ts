import { renderBookOpenTextIcon24 } from '../../../../icons';
import { renderButton } from '../../../../partials';
import { insertIf } from '../../../../helpers';

export function renderWikiDisclaimer(kind: 'default' | 'error' | 'warning') {
  const iconWrap = E('span', {
    class: 'pdk_diagnostic-page__right-bar__wiki__icon',
  });
  iconWrap.appendChild(renderBookOpenTextIcon24());

  const className = [
    'pdk_diagnostic-page__right-bar__wiki',
    ...insertIf(kind === 'error', [
      'pdk_diagnostic-page__right-bar__wiki--error',
    ]),
    ...insertIf(kind === 'warning', [
      'pdk_diagnostic-page__right-bar__wiki--warning',
    ]),
  ].join(' ');

  return E('div', { class: className }, [
    E('div', { class: 'pdk_diagnostic-page__right-bar__wiki__content' }, [
      iconWrap,
      E('div', { class: 'pdk_diagnostic-page__right-bar__wiki__texts' }, [
        E('b', {}, _('Troubleshooting')),
        E('div', {}, _('Internet not working? Contact support')),
      ]),
    ]),
    renderButton({
      classNames: ['cbi-button-save'],
      text: _('Support'),
      onClick: () =>
        window.open(
          'https://t.me/MBzeGuardHelpBot',
          '_blank',
          'noopener,noreferrer',
        ),
    }),
  ]);
}
