/*
 * Copyright 2007 The JA-SIG Collaborative. All rights reserved. See license
 * distributed with this file and available online at
 * http://www.ja-sig.org/products/cas/overview/license/
 */
package org.jasig.cas.adaptors.trusted.authentication.principal;

import org.jasig.cas.authentication.principal.SimplePrincipal;

import junit.framework.TestCase;

/**
 * 
 * @author Scott Battaglia
 * @version $Revision: 14064 $ $Date: 2007-06-10 09:17:55 -0400 (Sun, 10 Jun 2007) $
 * @since 3.0.5
 *
 */
public class PrincipalBearingCredentialsTests extends TestCase {

        private PrincipalBearingCredentials principalBearingCredentials;
        
        public void setUp() throws Exception {
            this.principalBearingCredentials = new PrincipalBearingCredentials(new SimplePrincipal("test"));
        }
        
        public void testGetOfPrincipal() {
            assertEquals("test", this.principalBearingCredentials.getPrincipal().getId());
        }
}
