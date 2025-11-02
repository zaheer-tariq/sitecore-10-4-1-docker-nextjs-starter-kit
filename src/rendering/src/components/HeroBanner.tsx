import { JSX } from 'react';
import { Text, Field, withDatasourceCheck, ImageField } from '@sitecore-jss/sitecore-jss-nextjs';
import { ComponentProps } from 'lib/component-props';

export type HeroBannerProps = ComponentProps & {
  fields: {
    Title: Field<string>;
    Subtitle: Field<string>;
    Image: ImageField;
  };
};

const HeroBanner = ({ fields }: HeroBannerProps): JSX.Element => {
  const bannerStyle = {
    backgroundImage: `url(${fields.Image?.value?.src})`,
  };
  return (
    <>
      <section className="hero is-medium is-black" style={bannerStyle}>
        <div className="hero-body">
          <div className="container">
            <Text field={fields.Title} tag="h1" className="title" />
            <Text field={fields.Subtitle} tag="h2" className="title" />
          </div>
        </div>
      </section>
      <section className="hero-content">
        <div className="container">
          <div className="content-wrapper">
            <h3>Welcome to BasicCompany</h3>
            <p>
              Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor
              incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud
              exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure
              dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
            </p>
            <p>
              Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt
              mollit anim id est laborum. Sed ut perspiciatis unde omnis iste natus error sit
              voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab
              illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.
            </p>
            <p>
              Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia
              consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro
              quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit.
            </p>
          </div>
        </div>
      </section>
    </>
  );
};

export default withDatasourceCheck()<HeroBannerProps>(HeroBanner);
