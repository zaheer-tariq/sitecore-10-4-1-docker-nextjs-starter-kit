import { JSX } from 'react';
import { Field } from '@sitecore-jss/sitecore-jss-nextjs';
import { ComponentProps } from 'lib/component-props';

type FooterProps = ComponentProps & {
  fields: {
    heading: Field<string>;
    content: Field<string>;
  };
};

const Footer = ({}: FooterProps): JSX.Element => (
  <div className="contentBlock">
    <footer className="footer">
      <div className="copyright">
        <p>&copy; {new Date().getFullYear()} BasicCompany. All rights reserved.</p>
      </div>
    </footer>
  </div>
);

export default Footer;
