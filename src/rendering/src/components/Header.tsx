import { JSX } from 'react';
import { Field, useSitecoreContext, ImageField, Image } from '@sitecore-jss/sitecore-jss-nextjs';
import { ComponentProps } from 'lib/component-props';
import config from 'temp/config';

interface RouteFields {
  [key: string]: unknown;
  HeaderLogo: ImageField;
}

type HeaderProps = ComponentProps & {
  fields: {
    heading: Field<string>;
    content: Field<string>;
  };
};

const publicUrl = config.publicUrl;

const Header = ({}: HeaderProps): JSX.Element => {
  const { sitecoreContext } = useSitecoreContext();
  const routeFields = sitecoreContext?.route?.fields as RouteFields;

  return (
    <header>
      <nav>
        <ul>
          <li>
            <a href="/">
              {routeFields?.HeaderLogo ? (
                <Image field={routeFields.HeaderLogo} alt="Header Logo" />
              ) : (
                <img src={`${publicUrl}/sc_logo.svg`} alt="Sitecore" />
              )}
            </a>
          </li>
          <li>
            <a href="https://jss.sitecore.com">JSS Documentation</a>
          </li>
          <li>
            <a href="https://github.com/Sitecore/jss">JSS Repository</a>
          </li>
        </ul>
      </nav>
    </header>
  );
};

export default Header;
