import { Flex, Spacer, Separator, Link } from '@artsy/palette'
import React from "react"


const Footer = () => {
  return (
    <>
      <Separator mb={2} mt={1}/>
      <Flex FlexDirection="row" flexWrap="nowrap" justifyContent="center" alignContent="space-around">
        <Link href="about" m={1}>About</Link>
        <Link href="terms" m={1}>Terms</Link>
      </Flex>
      <div style={{textAlign: 'center'}}>© 2019 Dobar All Rights Reserved. </div>
    </>
  )
}

export default Footer
